class UserNewsletter < ActionMailer::Base
  default from: "Santa Cruz Daily <lineup@santacruzdaily.com>"
  helper ApplicationHelper
  layout 'mailer'

  def send_email(user)
    @user = user
    @tags = @user.tags
    @articles = Article.tagged_with(@tags, :any => :true).status(1).active.popular.limit(5)
    mail( :to => @user.email,
    :subject => 'The Santa Cruz Daily lineup' )
  end
end
