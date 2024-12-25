require 'swagger_helper'

RSpec.describe 'URLs API', type: :request do
  path '/api/v1/urls' do
    post 'Creates a short URL' do
      consumes 'application/json'

      # Define the parameter for the long URL
      parameter name: :url, in: :body, schema: {
        type: :object,
        properties: {
          long_url: { type: :string }
        },
        required: ['long_url']
      }

      # Add the Authorization header
      parameter name: 'Authorization', in: :header, type: :string, description: 'Bearer token for authentication'

      # Mock `generate_url_hash` to return a fixed value for testing
      before do
        allow_any_instance_of(UrlsController).to receive(:generate_url_hash).and_return('abcdef233')
      end

      # Static bearer token for authorization (using the provided hash)
      let(:Authorization) { 'Bearer f57976c642697285620b353ac5ee1239' }

      # Success response (200) - When URL already exists
      response '200', 'URL already exists and returns the shortened URL' do
        let(:url) { { long_url: 'https://www.example.com' } }

        before do
          # Mock an existing URL in the database with the same URL hash
          existing_url = Url.create(long_url: url[:long_url], shortened_url: 'abcd1234', url_hash: 'abcdef233')
        end

        run_test! do |response|
          expect(response.body).to include("shortened_url")
          expect(response.body).to include("http://127.0.0.1:3000/urls/#{existing_url.shortened_url}")
        end
      end

      # Success response (201) - When new URL is created
      response '201', 'URL created successfully' do
        let(:url) { { long_url: 'https://www.example.com' } }

        before do
          # Ensure no existing URL exists to create a new one
          Url.destroy_all
        end

        run_test! do |response|
          expect(response.body).to include("shortened_url")
          expect(response.body).to include("http://127.0.0.1:3000/urls/")
        end
      end

      # Invalid URL (422)
      response '422', 'Invalid URL' do
        let(:url) { { long_url: 'invalid_url' } }

        run_test! do |response|
          expect(response.body).to include("error")
          expect(response.body).to include("Invalid URL")
        end
      end

      # Unauthorized (401) - Invalid token
      response '401', 'Unauthorized' do
        let(:Authorization) { 'Bearer invalid_token_example' } # Simulate an invalid token
        let(:url) { { long_url: 'https://www.example.com' } }

        run_test!
      end
    end
  end
end