class License < BaseItem

  field :licensed_to, :type => String
  field :comments, :type => String

  mount_uploader :license_file, LicenseFileUploader

  encrypted_field :license_key, :key => Roswell::Application.config.roswell_key

end
