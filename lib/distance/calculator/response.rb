require 'faraday'

module DistanceCalculator
  # Faraday response middleware
  module Response
    # Raises a Gistance exception based on status response or HTTP status codes returned by the API
    class RaiseError < Faraday::Response::Middleware
    end
  end
end
