require 'digest'

class UrlsController < ApplicationController

  def index
    @urls = Url.all.order(created_at: :desc)
    respond_to do |format|
      format.html
      format.json { render json: @urls }
    end
  end


  def new
    @url = Url.new
  end

  def create
    @url = Url.new(url_params)
    # Check if the URL already exists based on its hash
    url_hash = generate_url_hash(@url.long_url)
    existing_url = Url.find_by(url_hash: url_hash)

    if existing_url
      Rails.logger.info "URL already exists. Returning existing shortened URL: #{existing_url.shortened_url}"
      render :new, status: :ok, locals: { shortened_url:  existing_url.shortened_url }
    else
      @url.shortened_url = generate_shortened_url
      @url.url_hash = url_hash # Store the unique hash for idempotency

      if @url.save
        Rails.logger.info "New shortened URL created: #{@url.shortened_url}"
        render :new, status: :created, locals: { shortened_url: @url.shortened_url }
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def show
    @url = Url.find_by(shortened_url: params[:id])
    if @url&.is_live?
      Rails.logger.info "Redirecting to: #{@url.long_url}"
      redirect_to @url.long_url, allow_other_host: true, turbo: false
    else
      redirect_to root_path, alert: 'URL not found or unsafe redirect'
    end
  end

  private

  def url_params
    params.require(:url).permit(:long_url)
  end

  def generate_shortened_url
    random_string =  SecureRandom.hex(6) # Generate a random 12-character string
  end

  def generate_url_hash(long_url)
    Digest::SHA256.hexdigest(long_url) # Generate a unique hash for the long URL
  end
end