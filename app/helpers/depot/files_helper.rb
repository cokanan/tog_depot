module Depot
  module FilesHelper

    def tag_cloud_files(classes)
      tags = Depot::File.tag_counts(:conditions => ['privacy = ?', Depot::File::PUBLIC])
      return if tags.empty?
      max_count = tags.sort_by(&:count).last.count.to_f
      tags.each do |tag|
        index = ((tag.count / max_count) * (classes.size - 1)).round
        yield tag, classes[index]
      end
    end

    def new_file_url(type=TYPE_FILE, father=nil)
      type_name = type == Depot::File::TYPE_FOLDER ? 'folder' : 'file' 
      if father && father.folder && (logged_in? && father.user == current_user)
        new_child_member_depot_file_path(type_name, father)
      else
        new_member_depot_file_path(type_name)
      end
    end

    def user_files_path(file, user)
      if (file.father)
        father_path = user_files_path(file.father, user)
        file_path = link_for_file(file)
        return  "#{father_path}/#{file_path}"
      else
        return "/#{link_to(I18n.t('tog_depot.model.root'), user_depot_files_path(:user_id => user))}/#{link_for_file(file)}"
      end
    end
    
    def path(file, for_member=false)
      if (file.father)
        father_path = path(file.father, for_member)
        file_path = link_for_file(file, for_member)
        return  "#{father_path}/#{file_path}"
      else
        if for_member
          return "/#{link_to(I18n.t('tog_depot.model.root'), member_depot_files_path)}/#{link_for_file(file, for_member)}"
        else
          return "/#{link_to(I18n.t('tog_depot.model.root'), depot_files_path)}/#{link_for_file(file, for_member)}"
        end   
      end
    end
    
    def write_icon(file)
      if file.folder
        image_tag '/tog_depot/images/tog-depot_iconfolder_48px.gif'
      else
        image_tag '/tog_depot/images/tog-depot_iconfile_48px.gif'
      end
    end
    
    private
    
      def link_for_file(file, for_member=false)
        unless file.new_record?
          if for_member
            link_to file.name, member_depot_file_path(file)
          else
            link_to file.name, depot_file_path(file)
          end
        end
      end

  end
	
end
