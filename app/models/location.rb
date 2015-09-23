class Location < ActiveRecord::Base
  belongs_to :article
  belongs_to :user

  geocoded_by :full_address
  after_validation :geocode

  def full_address
    "#{line_1}, #{postal_code}, #{city}"
  end

end
