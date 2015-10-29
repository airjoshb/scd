class Article < ActiveRecord::Base
  validates_presence_of :title, :body
  validates_numericality_of :user_id

  belongs_to :user
  has_many :events, -> { order(start_date: :desc) }, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :statuses, dependent: :destroy
  has_many :recommendations, dependent: :destroy
  has_many :recommended_users, :through => :recommendations, :source => :user


  acts_as_taggable
  acts_as_taggable_on

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  default_scope {order("publish_date DESC") }

  after_create :status_default

  accepts_nested_attributes_for  :events
  accepts_nested_attributes_for :locations

  scope :active, -> { where('publish_date <= ?', Time.current).order('publish_date DESC') }
  scope :next, lambda { |id| where("id > ?", id).order("id ASC")}


  scope :popular, -> {
    joins('LEFT OUTER JOIN recommendations ON articles.id = recommendations.article_id')
    .select('articles.*, count(recommendations.id) as "user_count"')
    .group('articles.id')
    .order('user_count desc')
  }


  mount_uploader :image, ImageUploader


  def next
    Article.active.where("articles.id > ?", self.id).order("id ASC").first
  end

  def previous
    Article.active.tagged_with(["tags", "food", "adventure", "liveevent", "shopping", "tinyvacation", "location"], :on => :tags, :any => true).where("articles.id < ?", self.id).order("id ASC").last
  end

  def find_status(status)
   return !!self.statuses.find_by_status(status)
  end

  def self.status(status)
    where(:statuses => {:status => status}).joins(:statuses)
  end


  def status_default
    self.statuses.build
    self.save
  end

  def current_week?
    date = Date.today.beginning_of_week
    return (date..date + 6.days).to_a
  end

  def word_count
    body.split.size
  end

  def reading_time
    (word_count / 200.0).ceil
  end

  def normalize_friendly_id(string)
    string.to_s.gsub("\'", "").parameterize
  end

  scope :popular, -> {
    joins('LEFT OUTER JOIN recommendations ON articles.id = recommendations.article_id')
    .select('articles.*, count(recommendations.id) as "user_count"')
    .group('articles.id')
    .order('user_count desc')
  }


end
