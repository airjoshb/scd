CarrierWave.configure do |config|

  config.storage    = :aws
  config.aws_bucket = 'stepone-scd'
  config.aws_acl    = :'public-read'
  config.asset_host = "https://d30gbhxlvcb3ti.cloudfront.net"
  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365

  config.aws_credentials = {
    access_key_id:     Rails.application.secrets.AWS_ACCESS_KEY_ID,
    secret_access_key: Rails.application.secrets.AWS_SECRET_ACCESS_KEY,
    region:            'us-west-1' # Required
  }

  module CarrierWave
    module MiniMagick
      def quality(percentage)
        manipulate! do |img|
          img.quality(percentage.to_s)
          img = yield(img) if block_given?
          img
        end
      end
    end
  end
end