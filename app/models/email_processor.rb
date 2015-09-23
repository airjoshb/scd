class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    # all of your application-specific code here - creating models,
    # processing reports, etc

    # here's an example of model creation
    user = User.find_or_create_by_email(@email.from[:email])
    user.articles.create!(
      title: @email.subject,
      body: @email.body
    )
  end
end