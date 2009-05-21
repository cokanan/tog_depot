class Member::Depot::FilesController < Member::BaseController
 
  before_filter :load_file, :only => [:show, :destroy, :edit, :update]
  before_filter :check_owner, :only => [:show, :destroy, :edit, :update]

  before_filter :calculate_disk_usage
  before_filter :quota

  def index
    @order = params[:order] || "name asc"
    @files = current_user.files.paginate(:per_page => 20, 
                                         :conditions => ['father_id = 0'],
                                         :page => params[:page], 
                                         :order => "folder desc, #{@order}")
  end

  def by_tag
    @tag  =  Tag.find_by_name(params[:tag_name])
    @my_files = current_user.files.find_tagged_with(@tag).paginate(:per_page => 10, :page => params[:page]) unless @tag.nil?
    @my_folders = current_user.filefolders.find_tagged_with(@tag) unless @tag.nil?
  end

  def show
    @file = current_user.files.find(params[:id])
    @page = params[:page] || 1 
    @children = @file.paginated_children(@page, 'name asc')
  end
 
  def new
    @file = Depot::File.new(:folder => params[:file_type] == 'folder')
    father = current_user.files.find(params[:father_id]) if params[:father_id]
    @file.father = father if father
  end
 
  def create
    
    if (@disk_usage > @quota)
       flash[:error] = I18n.t('tog_depot.member.quota_error')
       redirect_to member_depot_files_path
    end    
    
    @file = current_user.files.new(params[:file])
    @file.user_id = current_user.id
    father_id = params[:file][:father_id] || 0
    father = current_user.files.find(father_id) if father_id.to_i  > 0
    @file.father = father if father && father.user == current_user
 
    respond_to do |wants|
      if @file.save!
        wants.html do
          flash[:ok] = I18n.t('tog_depot.member.file_created') 
          redirect_to member_depot_file_path(@file)
        end
      else
        wants.html do
          flash.now[:error] = 'Failed to create a new file.'
          render :action => :new
        end
      end
    end
  end
  
  def tags
  end
 
  def edit
  end
  
  def update
    @file = current_user.files.find(params[:id])
    respond_to do |wants|
      if @file.update_attributes(params[:file])
         wants.html do
          flash[:ok] = I18n.t('tog_depot.member.file_updated') 
          redirect_to member_depot_file_path(@file)
        end
      else
        wants.html do
          flash.now[:error] = 'Failed to Update a new file.'
          render :action => :edit
        end
      end
    end
  end
  
  def destroy
    @file.destroy
    respond_to do |wants|
      wants.html do
        flash[:ok] = I18n.t('tog_depot.member.file_removed') 
        redirect_to member_depot_files_path
      end
    end
    
  end


  private 
  
    def load_file
      @file = current_user.files.find params[:id]
    end
  
    def check_owner
      unless @file.user == current_user
        flash[:error] = "You aren't this file's owner"
        redirect_to member_depot_files_path
      end      
    end
  
    def calculate_disk_usage
      @disk_usage = current_user.files.sum('file_file_size').to_i
    end
    
    def quota
      @quota = Tog::Plugins.settings(:tog_depot, "file.user_quota_mb").to_i.megabytes
    end
end
