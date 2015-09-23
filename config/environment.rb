# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

Date::DATE_FORMATS[:default] = "%b %d, %Y"
Time::DATE_FORMATS[:default] = "%H:%M"

ActionMailer::Base.smtp_settings = {
  :user_name => 'app41272541@heroku.com',
  :password => 'p7nhcidp3490',
  :domain => 'santacruzdaily.com',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}