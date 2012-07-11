class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.string :s3_access_key_id
      t.string :s3_secret_access_key
      t.string :bucket_name
      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
