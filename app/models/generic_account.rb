class GenericAccount < BaseItem

  field :username, :type => String
  field :comments, :type => String

  mount_uploader :license_file, LicenseFileUploader

  encrypted_field :password, :key => Roswell::Application.config.roswell_key

  validates_presence_of :username

end
