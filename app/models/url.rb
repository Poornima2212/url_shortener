class Url < ApplicationRecord
    # Validate presence and format of long_url
    validates :long_url, presence: true, length: { maximum: 2048, message: "must be less than 2048 characters" }, format: { with: /\A(http|https):\/\/[^\s]+/i, message: "must be a valid URL starting with http or https" }
  
    # Validate presence and uniqueness of shortened_url
    validates :shortened_url, presence: true, uniqueness: true
    validates :url_hash, presence: true, uniqueness: true
    after_commit :set_expiry

    EXPIRY = 48.hours.to_i.freeze


    def set_expiry
        # Store the shortened URL in Redis with expiration (2 days)
        $redis.set("ISLIVE::#{self.id}", true, ex: EXPIRY)
    end

    def is_live?
        $redis.exists?("ISLIVE::#{self.id}")
    end
end
