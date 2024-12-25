class Api::V1::UrlsController < ApplicationController
    before_action :authenticate_api_token

    def create
      url = Url.new(long_url: url_params[:long_url])
      # Check if the URL already exists based on its hash
      url_hash = generate_url_hash(url.long_url)
      existing_url = Url.find_by(url_hash: url_hash)
  
      if existing_url
        Rails.logger.info "URL already exists. Returning existing shortened URL: #{existing_url.shortened_url}"
        render json: { shortened_url:  "http://127.0.0.1:3000/urls/#{existing_url.shortened_url}" }, status: :ok
      else
        url.shortened_url = generate_shortened_url
        url.url_hash = url_hash # Store the unique hash for idempotency
  
        if url.save
          Rails.logger.info "New shortened URL created: #{url.shortened_url}"
          render json: { shortened_url: "http://127.0.0.1:3000/urls/#{url.shortened_url}" }, status: :created
        else
          render json: { error: "Invalid URL" }, status: :unprocessable_entity
        end
      end
    end

    private
  
    def url_params
      params.require(:url).permit(:long_url)
    end
  
    def generate_shortened_url
      SecureRandom.hex(6)  # Generate a random 12-character string
    end

    def generate_url_hash(long_url)
      Digest::SHA256.hexdigest(long_url) # Generate a unique hash for the long URL
    end
  
    def authenticate_api_token
      token = request.headers['Authorization'].to_s.split(' ').last
      expected_token = Rails.application.credentials.api[:token]
      unless token == expected_token
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end
  end
  