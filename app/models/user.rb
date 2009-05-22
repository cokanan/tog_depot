class User < ActiveRecord::Base
  
  has_many :files, :class_name => "Depot::File", :dependent => :destroy

end
