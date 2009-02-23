require_plugin 'tog_core'
require_plugin 'seo_urls'
require_plugin 'paperclip'

Dir[File.dirname(__FILE__) + '/locale/**/*.yml'].each do |file|
  I18n.load_path << file
end

Tog::Interface.sections(:site).add "Files", "/depot/files"     

Tog::Interface.sections(:member).add "My files", "/member/depot/files"

Tog::Plugins.settings :tog_depot, "file.max_size_file_kb"	=> "500",    #kb
                                  "file.user_quota_mb"	  => "50"      #mb

Tog::Plugins.helpers Depot::FilesHelper
