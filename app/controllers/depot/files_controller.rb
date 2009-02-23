class Depot::FilesController < ApplicationController

  before_filter :load_file, :only => [:show, :download]
  before_filter :check_privacy, :only => [:show, :download]

  def index
    @order = params[:order] || "name asc"
    @page = params[:page] || 1
    @files = Depot::File.paginate(:per_page => 10, 
                                  :conditions => ['father_id = 0 and privacy = ?', Depot::File::PUBLIC],
                                  :page => @page, 
                                  :order => "folder desc, #{@order}")    

  end

  def show
#    @extension = @file.filename.to_s.scan(/\.\w+$/)
  end

  def by_tag
    @tag  =  Tag.find_by_name(params[:tag_name])
    @page = params[:page] || 1    
    @files = Depot::File.find_tagged_with(@tag, 
                                          :conditions => ['privacy = ?', Depot::File::PUBLIC]).paginate(
                                              :per_page => 20, 
                                              :page => @page) 
  end

  def download
    @file.count_download!
    send_file(@file.file.path)
  end
  
  private
    
    def load_file
      @file = Depot::File.find params[:id]
    end
	
    def check_privacy
      unless @file.privacy == Depot::File::PUBLIC || @file.user == current_user
        flash[:error] = I18n.t('tog_depot.site.privacy_error')
        redirect_to depot_files_path
      end
    end
    	
end

