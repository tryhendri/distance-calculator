module DistanceCalculator
  # Methods for Gistance configuration
  module Configuration
    # Configurable options
    VALID_OPTIONS = %i[
      api_endpoint
      api_key
      language
      units
      sensor
      business
    ].freeze

    # Default Google Distance Matrix API endpoint
    DEFAULT_API_ENDPOINT = 'https://maps.googleapis.com/maps/api/distancematrix/json'.freeze

    attr_accessor(*VALID_OPTIONS)

    # @private
    def self.extended(base_obj)
      base_obj.initialize_default_options
    end

    # Set configuration options using a block
    def configure
      yield self
    end

    # Default options
    def options
      VALID_OPTIONS.inject({}) { |o, k| o.merge!(k => send(k)) }
    end

    # Initialize default options
    def initialize_default_options
      self.api_endpoint = DEFAULT_API_ENDPOINT
      self.api_key = nil
      self.language = 'en'
      self.units = 'metric'
      self.sensor = false
      self.business = nil
    end

    # Reset configuration options to default values
    def reset!
      initialize_default_options

      self
    end
  end
end
