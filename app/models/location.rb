class Location < ActiveRecord::Base
  belongs_to :article
  belongs_to :user

  validates_presence_of :line_1, :postal_code, :city

  geocoded_by :full_address
  after_validation :geocode, :if => lambda{ |obj| obj.full_address_changed? }

  def full_address
    "#{line_1}, #{postal_code}, #{city}, #{state_or_province}"
  end

end
