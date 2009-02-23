# Add your custom routes here.  If in config/routes.rb you would 
# add <tt>map.resources</tt>, here you would add just <tt>resources</tt>

with_options(:controller => 'depot/files', :conditions => { :method => :get }) do |file|
  file.tag_depot_files      'depot/files/tag/:tag_name', :action => 'by_tag'
  file.depot_files_order    'depot/files/order/:order',  :action => 'index'
  file.depot_files_download 'depot/files/download/:id', :action => 'download'
end

with_options(:controller => 'member/depot/files', :conditions => { :method => :get }) do |file|
  file.new_child_member_depot_file 'member/depot/files/new/:file_type/:father_id', :action => 'new'
  file.new_member_depot_file       'member/depot/files/new/:file_type', :father_id => nil, :action => 'new' 
  file.tag_member_depot_files      'member/depot/files/tag/:tag_name', :action => 'by_tag'
  file.member_depot_files_order    'member/depot/files/order/:order',  :action => 'index'
  file.member_depot_files_download 'member/depot/files/download/:id', :action => 'download'
end

namespace(:depot) do |depot|
  depot.resources :files
end

namespace(:member) do |member| 
   member.namespace(:depot) do |depot|
      depot.resources :files
   end
end


