FactoryBot.define do
    factory :url do
      long_url { 'https://www.example.com' }
      url_hash { Digest::SHA256.hexdigest(long_url) }
      shortened_url { SecureRandom.hex(6) }
    end
end
