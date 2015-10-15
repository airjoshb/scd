class Location < ActiveRecord::Base
  belongs_to :article
  belongs_to :user

  validates_presence_of :line_1, :postal_code, :city

  geocoded_by :full_address
  after_validation :geocode, if: ->(obj){ obj.full_address.present? and obj.address_changed? }

  def address_changed?
    attrs = %w(line_1 city state_or_province postal_code)
    attrs.any?{|a| send "#{a}_changed?"}
  end

  def full_address
    "#{line_1}, #{postal_code}, #{city}, #{state_or_province}"
  end

end
