class UserNewsletter < ActionMailer::Base
  default from: "Santa Cruz Daily <lineup@santacruzdaily.com>"
  helper ApplicationHelper
  layout 'mailer'

  def send_weekly_email(user)
    @user = user
    @tags = @user.tags
    @upcoming = Article.status(1).active.joins(:events).where("events.start_date >= ? and events.start_date <= ?", Date.today.beginning_of_week, Date.today.beginning_of_week + 6 ).tagged_with(@tags, :any => :true).limit(5)
    @articles = Article.includes(:events).where(events:{id: nil}).tagged_with(@tags, :any => :true).active.status(1).limit(2)
    mail( :to => @user.email,
    :subject => 'What\'s happening this week from Santa Cruz Daily' )
  end

  def send_daily_email(user)
    @user = user
    @tags = @user.tags
    @upcoming = Article.status(1).active.joins(:events).where("events.start_date >= ? and events.start_date <= ?", Date.today, Date.today + 1 ).tagged_with(@tags, :any => :true).limit(5)
    @articles = Article.includes(:events).where(events:{id: nil}).tagged_with(@tags, :any => :true).active.status(1).limit(2)
    mail( :to => @user.email,
    :subject => 'What\'s happening today from Santa Cruz Daily' )
  end

  def send_monthly_email(user)
    @user = user
    @tags = @user.tags
    @upcoming = Article.status(1).active.joins(:events).where("events.start_date >= ? and events.start_date <= ?", Date.today.next_month.beginning_of_month, Date.today.next_month.end_of_month ).tagged_with(@tags, :any => :true).limit(5)
    @articles = Article.includes(:events).where(events:{id: nil}).tagged_with(@tags, :any => :true).active.status(1).limit(2)
    mail( :to => @user.email,
    :subject => 'What\'s happening next month from Santa Cruz Daily' )
  end
end
