class Article < ActiveRecord::Base
  validates_presence_of :title, :body
  validates_uniqueness_of :title
  validates_numericality_of :user_id

  belongs_to :user
  has_many :events
  has_many :locations
  has_many :statuses, dependent: :destroy
  has_many :recommendations, dependent: :destroy
  has_many :recommended_users, :through => :recommendations, :source => :user


  acts_as_taggable
  acts_as_taggable_on

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  attr_accessor :events
  attr_accessor :locations

  after_create :status_default

  scope :active, -> { where('publish_date <= ?', Time.current).order('publish_date DESC') }
  scope :next, lambda { |id| where("id > ?", id).order("id ASC")}

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

  def word_count
    body.split.size
  end

  def reading_time
    (word_count / 200.0).ceil
  end

  scope :popular, -> {
    joins('LEFT OUTER JOIN recommendations ON articles.id = recommendations.article_id')
    .select('articles.*, count(recommendations.id) as "user_count"')
    .group('articles.id')
    .order('user_count desc')
  }


end
