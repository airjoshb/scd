class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(auth)
    identity = find_or_create_by(uid: auth.uid, provider: auth.provider)
    identity.remote_avatar_url = auth.info.image
    identity.nickname = auth.info.nickname || auth.info.name
    case auth.provider
    when "twitter"
      identity.url = auth[:info][:urls][:Twitter]
    when "facebook"
      identity.url = auth.extra.raw_info.link
    end
    identity.save
    identity
  end

  mount_uploader :avatar, AvatarUploader


end