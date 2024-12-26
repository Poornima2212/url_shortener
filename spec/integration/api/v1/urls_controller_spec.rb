require 'swagger_helper'
require 'rails_helper'

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

      # Static bearer token for authorization (using the provided hash)
      let(:Authorization) { 'Bearer f57976c642697285620b353ac5ee1239' }

      before do
        Url.destroy_all
      end

      after do
        Url.destroy_all
      end

      # Success response (200) - When URL already exists
      response '200', 'URL already exists and returns the shortened URL' do
        let(:url) { { long_url: 'https://www.example.com' } }

        before do
          # Mock the URL hash generation to return a fixed value for testing
          allow_any_instance_of(UrlsController).to receive(:generate_url_hash).with(url[:long_url]).and_return('cdb4d88dca0bef8defe13d71624a46e7e851750a750a5467d53cb1bf273ab973')

          # Mock `Url.find_by` to simulate an existing URL
          existing_url = create(:url, long_url: url[:long_url], url_hash: 'cdb4d88dca0bef8defe13d71624a46e7e851750a750a5467d53cb1bf273ab973', shortened_url: 'abcd1234')
          allow(Url).to receive(:find_by).with(url_hash: 'cdb4d88dca0bef8defe13d71624a46e7e851750a750a5467d53cb1bf273ab973').and_return(existing_url)
        end

        run_test! do |response|
          expect(response.status).to eq(200)  # Ensure status matches expectation
          expect(response.body).to include("shortened_url")
          response_body = JSON.parse(response.body)
          expect(response_body['shortened_url']).to eq("http://127.0.0.1:3000/urls/abcd1234")
        end
      end

      # Success response (201) - When new URL is created
      response '201', 'URL created successfully' do
        let(:url) { { long_url: 'https://www.example.com' } }

        before do
          # Ensure no existing URL exists to create a new one

          # Mock the URL hash generation to return a fixed value for testing
          allow_any_instance_of(UrlsController).to receive(:generate_url_hash).with(url[:long_url]).and_return('testhash')
        end

        run_test! do |response|
          expect(response.status).to eq(201)  # Ensure status matches expectation
          expect(response.body).to include("shortened_url")
          expect(response.body).to include("http://127.0.0.1:3000/urls/")
        end
      end

      # Invalid URL (422)
      response '422', 'Invalid URL' do
        let(:url) { { long_url: 'invalid_url' } }

        before do
          # Mock the URL hash generation for invalid URL case
          allow_any_instance_of(UrlsController).to receive(:generate_url_hash).with(url[:long_url]).and_return('invalidhash')
        end

        run_test! do |response|
          expect(response.status).to eq(422)  # Ensure status matches expectation
          expect(response.body).to include("error")
          expect(response.body).to include("Invalid URL")
        end
      end

      # Unauthorized (401) - Invalid token
      response '401', 'Unauthorized' do
        let(:Authorization) { 'Bearer invalid_token_example' }  # Simulate an invalid token
        let(:url) { { long_url: 'https://www.example.com' } }

        run_test!
      end
    end
  end
end