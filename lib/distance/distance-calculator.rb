require 'distance/calculator/version'
require 'distance/calculator/configuration'
require 'distance/calculator/request'
require 'distance/calculator/connection'
require 'distance/calculator/cache'

# module Distance
module DistanceCalculator
  extend Configuration

  class Error < StandardError; end
  # Initialize lat and long in array for math formula
  class MathFormula
    def initialize(*args)
      @params = args
      @radius = 6367.45
    end

    # Returns the radius of the Earth in kilometers. The default is 6367.45.
    attr_reader :radius, :params

    # The default value is 6367.45.
    # See http://en.wikipedia.org/wiki/Earth_radius.
    def radius=(kms)
      if kms < 6357.0 || kms > 6378.0
        raise Error, "Proposed radius '#{kms}' is out of range"
      end

      @radius = kms
    end

    # Validate the latitude and longitude values. Latitudes must be between
    # 90.0 and -90.0 while longitudes must be between 180.0 and -180.0.
    def validate(arg)
      arg.each do |arg|
        if arg[0].to_f > 90 || arg[0].to_f < -90
          msg = "Latitude '#{arg[0]}' is invalid - must be between -90 and 90"
          raise Error, msg
        end
        if arg[1].to_f > 180 || arg[1].to_f < -180
          msg = "Longitude '#{arg[1]}' is invalid - must be between -180 and 180"
          raise Error, msg
        end
      end
    end

    # See http://en.wikipedia.org/wiki/Haversine_formula as math formula
    # @Example
    # coords = [['2.78788', '3.578787'], ['3.6565', '55.6434']], [['2.78788', '3.578787'], ['3.6565', '55.6434']], [['2.78788', '3.578787'], ['3.6565', '55.6434']]
    # DistanceCalculator::MathFormula.new(coords).calculate_distance_with_math
    def calculate_distance_with_math
      distance = []
      @params.each do |args|
        args.each_with_index do |arg, _index|
          validate(arg)
          lat1 = arg[0][0].to_f * Math::PI / 180
          lat2 = arg[1][0].to_f * Math::PI / 180
          lon1 = arg[0][1].to_f * Math::PI / 180
          lon2 = arg[1][1].to_f * Math::PI / 180
          dlat = lat2 - lat1
          dlon = lon2 - lon1

          a = (Math.sin(dlat / 2)**2) + (Math.cos(lat1) * Math.cos(lat2) * Math.sin(dlon / 2)**2)
          c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

          distance << radius * c
        end
      end
      distance
    end
  end

  # Calculate distances for a matrix of origins and destinations.
  # @param options [Hash] a customizable set of options
  # @option options [Hash] :origins an array of origins
  # @option options [Hash] :destinations an array of destination
  # @return [Hashie::Mash] the distance between origins and destinations
  # @see https://developers.google.com/maps/documentation/distancematrix/#DistanceMatrixRequests
  # @example
  #   DistanceCalculator::Api.new.calculate_distance_with_api(
  #     origins: ["48.92088132,2.210950607"],
  #     destinations: ["48.922024,2.206292"]
  #   )
  class Api
    attr_accessor(*Configuration::VALID_OPTIONS)
    include DistanceCalculator::Connection
    include DistanceCalculator::Request
    include DistanceCalculator::Cache

    def initialize(options = {})
      options = DistanceCalculator.options.merge(options)

      Configuration::VALID_OPTIONS.each do |key|
        send("#{key}=", options[key])
      end
    end

    def calculate_distance_with_api(options = {})
      options[:origins] = format_locations_array(options[:origins])
      options[:destinations] = format_locations_array(options[:destinations])

      delete_status_from_response(get(options))
    end

    private

    def format_locations_array(locations)
      locations.map { |location| format_location(location) }.join('|')
    end

    def format_location(location)
      return location if location_is_coordinates?(location)

      location.split(' ').join('+')
    end

    def location_is_coordinates?(location)
      location.to_s =~ /^\s*-?\d+\.\d+\,\s?-?\d+\.\d+\s*$/
    end

    def delete_status_from_response(response)
      response.delete(:status)

      response.rows.each do |row|
        row['elements'].each { |el| el.delete(:status) }
      end

      response
    end
  end
end
