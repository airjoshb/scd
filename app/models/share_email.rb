class ShareEmail < MailForm::Base
  attribute :name
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :file
  attribute :url

  attribute :message
  attribute :title
  attribute :recipient

  attributes :nickname,   :captcha => true


  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :subject => "This sounds like fun - #{title}",
      :to => "#{recipient}",
      :from => %("#{name}" <#{email}>)
    }
  end
end