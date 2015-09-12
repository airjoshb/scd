# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

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
    process :resize_to_limit => [100, 100]
  end

  version :nav do
    process :resize_to_limit => [150, 150]
  end

  version :small do
    process :resize_to_limit => [200, 200]
  end

  version :medium do
    process :resize_to_limit => [310, 310]
  end

  version :hero do
    process :resize_to_limit => [680, 680]
  end

  version :full do
    process :resize_to_limit => [960, 960]
  end

end
