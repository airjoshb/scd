class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    # all of your application-specific code here - creating models,
    # processing reports, etc

    # here's an example of model creation
    user = User.find_or_initialize_by(email: @email.from[:email])
    user.articles.create!(
      title: @email.subject,
      body: @email.body,
      image: @email.attachments.first
    )
  end
end