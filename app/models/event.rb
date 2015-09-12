class Event < ActiveRecord::Base
  belongs_to :article

  scope :active, -> { where('start_date >= ?', Time.current + 3.hours)}
  scope :inactive, -> { where('start_date <= ?', Time.current + 3.hours) }

end
