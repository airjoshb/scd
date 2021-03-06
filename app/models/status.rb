class Status < ActiveRecord::Base
  enum status: [:pending, :published, :declined, :approved, :deleted]

  belongs_to :article
  validates_presence_of :article_id

  default_scope {order("Created_at DESC") }
end
