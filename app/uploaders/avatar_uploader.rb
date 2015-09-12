# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  #storage :file
  storage :aws

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :quality => 55

  version :thumb do
    process :resize_to_limit => [50, 50]
  end

  version :small do
    process :resize_to_limit => [100, 100]
  end

  version :medium do
    process :resize_to_limit => [200, 200]
  end


end