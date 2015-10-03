# Preview all emails at http://localhost:3000/rails/mailers/user_newsletter
class UserNewsletterPreview < ActionMailer::Preview
  def send_email
    user = User.first
    UserNewsletter.send_email(user)
  end

end
