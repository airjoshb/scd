every :sunday, :at => '6am' do
   runner "User.mail_newsletter_weekly"
end

every 1.day, :at => '6am' do
   runner "User.mail_newsletter_daily"
end

every '0 6 29 * *'  do
   runner "User.mail_newsletter_monthly"
end