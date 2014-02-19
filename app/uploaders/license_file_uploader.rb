# encoding: utf-8

class LicenseFileUploader < CarrierWave::Uploader::Base

  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  storage :grid_fs

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    'http://d39ya49a1fwv14.cloudfront.net/wp-content/uploads/2013/01/HIMYM.jpg'
  end

end
