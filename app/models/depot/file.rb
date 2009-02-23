class Depot::File < ActiveRecord::Base

  acts_as_commentable
  acts_as_taggable
  seo_urls
  
  TYPE_FILE = false
  TYPE_FOLDER = true
  
  PUBLIC =  0
  PRIVATE = 1

  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  belongs_to :father, :class_name => "Depot::File", :foreign_key => "father_id"
  
  has_many :children, :class_name => "Depot::File", :foreign_key => "father_id", :dependent => :destroy

  has_attached_file :file, {
    :url => "/system/:class/:attachment/:id/:style_:basename.:extension",
  }.merge(Tog::Plugins.storage_options)
      
  validates_attachment_size :file, :message => I18n.t('tog_depot.model.validations.file_size'),
    :less_than => Tog::Plugins.settings(:tog_depot, "file.max_size_file_kb").to_i.kilobytes

  attr_accessible :name, :description, :folder, :tag_list, :privacy, :downloads, :file
  validates_presence_of :name  
  
  def paginated_children(page=1, order='name asc')
    self.children.paginate(:per_page => 10, 
                           :page => page, 
                           :order => "folder desc, #{order}")
  end
  
  def creation_date(format=:short)
    I18n.l(self.created_at, :format => format)
  end  

  def type_to_name
    self.folder ? 'folder' : 'file'
  end
  
  def count_download!
    self.downloads += 1
    self.save!
  end
    
  def private?
    self.privacy == Depot::File::PRIVATE
  end
  
  def path
    self.father == nil ? "/#{I18n.t('tog_depot.model.root')}" : "#{self.father.path}/#{self.name}"
  end

  def owner
    user
  end

end

