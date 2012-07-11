class Setting < ActiveRecord::Base
  attr_accessor :url
  attr_accessible :s3_access_key_id, :s3_secret_access_key, :url

  validates_presence_of :s3_access_key_id, :s3_secret_access_key
  validate :s3_settings_must_be_valid

  after_create :create_bukcet_and_upload_crossdomain_xml

  def self.instance
    first
  end

  def self.s3
    AWS::S3.new(:access_key_id => instance.s3_access_key_id, :secret_access_key => instance.s3_secret_access_key)
  end

  def self.no_s3_settings_yet?
    instance.nil?
  end

  def self.s3_settings_valid?
    instance.test_connection
  end

  def test_connection
    conn = AWS::S3.new(:access_key_id => self.s3_access_key_id, :secret_access_key => self.s3_secret_access_key)
    conn.buckets.each do
      # Nothing, just testing the connection
    end
    true
  rescue AWS::S3::Errors::InvalidAccessKeyId
    false
  end

  private

  def create_bukcet_and_upload_crossdomain_xml
    self.bucket_name = "#{Digest::MD5.hexdigest(self.url)}-#{SecureRandom.hex(16)}"
    save!

    Thread.new do
      bucket = self.class.s3.buckets.create(self.bucket_name)
      object = bucket.objects('crossdomain.xml')
      object.write(:file => Rails.root.join('config','crossdomain.xml'), :acl => :public_read)
    end
  end

  def s3_settings_must_be_valid
    unless s3_access_key_id.blank? || s3_secret_access_key.blank?
      errors[:base] << I18n.t(:s3_credentials_invalid) unless self.test_connection
    end
  end
end
