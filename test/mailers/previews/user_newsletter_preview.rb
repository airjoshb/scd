# Preview all emails at http://localhost:3000/rails/mailers/user_newsletter
class UserNewsletterPreview < ActionMailer::Preview
  def send_weekly_email
    user = User.find(25)
    UserNewsletter.send_weekly_email(user)
  end

  def send_daily_email
    user = User.find(25)
    UserNewsletter.send_daily_email(user)
  end

  def send_monthly_email
    user = User.find(25)
    UserNewsletter.send_monthly_email(user)
  end

end
