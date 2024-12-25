require 'swagger_helper'

RSpec.describe 'URL Shorteners API', type: :request do
  # Define the POST request for creating short URLs
  path '/api/v1/urls' do
    post 'Creates a short URL' do
      tags 'URL Shorteners'  # Tags for the endpoint
      consumes 'application/json'  # The accepted content type

      # Define request body parameters
      parameter name: :url, in: :body, schema: {
        type: :object,
        properties: {
          long_url: { type: :string, example: 'https://www.example.com' }
        },
        required: ['long_url']  # Make long_url a required field
      }

      # Response when URL is created successfully
      response '201', 'short URL created' do
        let(:url) { { long_url: 'https://www.example.com' } }  # Example request body
        run_test!  # Run the test and generate the response
      end

      # Response for unauthorized access (if token is invalid or missing)
      response '401', 'unauthorized' do
        let(:url) { { long_url: 'https://www.example.com' } }
        before { allow_any_instance_of(Api::V1::UrlsController).to receive(:authenticate_api_token).and_return(false) }
        run_test!  # Run the test and expect a 401 response
      end

      # Response for invalid URL input
      response '422', 'invalid URL' do
        let(:url) { { long_url: 'invalid_url' } }  # Invalid URL
        run_test!
      end
    end
  end
end
