require_plugin 'tog_core'
require_plugin 'seo_urls'
require_plugin 'attachment_fu'

Dir[File.dirname(__FILE__) + '/locale/**/*.yml'].each do |file|
  I18n.load_path << file
end

Tog::Interface.sections(:site).add "Files", "/depot/files"     

Tog::Interface.sections(:member).add "My files", "/member/depot/files"

Tog::Plugins.settings :tog_depot, "file.max_size_file"	=> "5000",
                                  "file.max_size_storage"	=> "500000"

Tog::Plugins.helpers Depot::FilesHelper
