class User < ActiveRecord::Base
  enum role: [:user, :subscriber, :admin, :sponsor]
  enum frequency: [:monthly, :weekly, :daily]

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  has_many :articles, :dependent => :destroy
  has_many :locations, :dependent => :destroy
  has_many :identities, :dependent => :destroy
  has_many :recommendations
  has_many :recommended_users, :through => :recommendations, :source => :article


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :omniauthable,
        :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :login
  attr_accessor :stripe_token
  attr_accessor :locations
  accepts_nested_attributes_for :articles

  after_create :default_role

  # before_save :update_stripe
  # before_destroy :cancel_subscription

  acts_as_taggable
  acts_as_taggable_on

  #validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  validates_uniqueness_of :username, :case_sensitive => false
  validates_uniqueness_of :email,  :case_sensitive => false

  def password_required?
    if !persisted?
      !(password != "")
    else
      !password.nil? || !password_confirmation.nil?
    end
  end

  def role?(role)
   return !!self.roles.find_by_name(role.to_s)
  end

  def recommended?(article)
    recommended_users.include?(article)
  end

  def recommend(article)
    recommendations.create(article_id: article.id)
  end

  def unrecommend(article)
    recommendations.find_by(article_id: article.id).destroy
  end

  def add_role(role)
    self.role ||= role
    self.save
  end

  def self.mail_newsletter_weekly
    @user = User.where(frequency: 1)
    @user.each do |u|
      UserNewsletter.send_weekly_email(u).deliver
    end
  end

  def self.mail_newsletter_monthly
    @user = User.where(frequency: 0)
    @user.each do |u|
      UserNewsletter.send_monthly_email(u).deliver
    end
  end

  def self.mail_newsletter_daily
    @user = User.where(frequency: 2)
    @user.each do |u|
      UserNewsletter.send_daily_email(u).deliver
    end
  end

  #->Prelang (user_login:devise/username_login_support)
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", {value: login.downcase}]).first
    else
      where(conditions).first
    end
  end

  def update_stripe
    return if email.include?('@gotostepone.com') or  email.include?("updatemyemail.com")
    if stripe_customer_id.nil?
      if !stripe_token.present?
        raise "Stripe token not present. Can't create account."
      end
      customer = Stripe::Customer.create(
        :email => email,
        :description => name,
        :card => stripe_token
      )
    else
      customer = Stripe::Customer.retrieve(stripe_customer_id)
      if stripe_token.present?
        customer.card = stripe_token
      end
      customer.email = email
      customer.description = name
      customer.save
    end
    self.last_4_digits = customer.sources.first.last4
    self.stripe_customer_id = customer.id
    self.stripe_token = nil
  rescue Stripe::StripeError => e
    logger.error "Stripe Error: " + e.message
    errors.add :base, "#{e.message}."
    self.stripe_token = nil
    false
  end

  def cancel_subscription
    unless stripe_customer_id.nil?
      customer = Stripe::Customer.retrieve(stripe_customer_id)
      unless customer.nil? or customer.respond_to?('deleted')
        customer.delete
      end
    end
  rescue Stripe::StripeError => e
    logger.error "Stripe Error: " + e.message
    errors.add :base, "Unable to cancel your subscription. #{e.message}."
    false
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          name: auth.info.name,   # assuming the user model has a name
          username: auth.info.nickname,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end


  devise authentication_keys: [:login]

  private

  def default_role
    self.user!
  end
end