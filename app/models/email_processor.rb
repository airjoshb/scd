class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    # all of your application-specific code here - creating models,
    # processing reports, etc
    # here's an example of model creation
    user = User.find_or_initialize_by(email: @email.from[:email])
    a = user.articles.create!(
      title: @email.subject,
      body: @email.body,
      image: @email.attachments.first
    )
    if @email.raw_text.match('subhead:').present?
      a.subhead = @email.raw_text.match(/subhead:(.*)/)[1]
    end
    if @email.raw_text.match('event:').present?
      start_date =  @email.raw_text.match(/start:(.*)/)[1]
      end_date =  @email.raw_text.match(/end:(.*)/)[1]
      a.events.create!(start_date: start_date.to_datetime, end_date: end_date.to_datetime)
    end
    if @email.raw_text.match('location:').present?
      line_1 = @email.raw_text.match(/line_1:(.*)/)[1]
      line_1 = @email.raw_text.match(/line_2:(.*)/)[1]
      line_1 = @email.raw_text.match(/city:(.*)/)[1]
      line_1 = @email.raw_text.match(/postal_code:(.*)/)[1]
      a.locations.create!(line_1: line_1, line_2: line_2, city: city, state_or_province: "CA", postal_code: postal_code)
    end
    a.save
  end


end