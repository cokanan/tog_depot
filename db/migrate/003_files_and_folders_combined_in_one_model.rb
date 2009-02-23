class FilesAndFoldersCombinedInOneModel < ActiveRecord::Migration
  def self.up
    drop_table :files_folder
    drop_table :files
    
    create_table :files do |t|
      t.string   :name
      t.text     :description
      t.integer  :user_id
			t.integer  :privacy
			t.integer  :downloads, :default => 0
			t.boolean  :folder, :default => false
			t.integer  :father_id, :default => 0
      t.string   :file_file_name
      t.string   :file_content_type
      t.integer  :file_file_size, :default => 0
      t.datetime :file_updated_at			
      t.timestamps
    end    
  end

  def self.down
    drop_table :files
  
    create_table :files do |t|
      t.string  :title
      t.text    :description
      t.integer :user_id
			t.string  :filename
			t.integer :size
			t.string  :content_type
			t.string  :state
			t.integer :filefolder_id
			t.integer :num_download, :default => 0

      t.timestamps
    end    
    create_table :files_folder do |t|
      t.string  :title
      t.text    :description
      t.integer :user_id
			t.string  :state

      t.timestamps
    end    
  end
end
