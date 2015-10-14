class LineupMailer < ActionMailer::Base
  default from: "Santa Cruz Daily <lineup@santacruzdaily.com>"
  helper ApplicationHelper
  layout 'mailer'

  def send_email(email, cart_line_items)
    @articles = Article.where(id: cart_line_items)
    mail( :to => email,
    :subject => 'Your personal guide to Santa Cruz Restaurant Week | Santa Cruz Daily' )
  end


end
