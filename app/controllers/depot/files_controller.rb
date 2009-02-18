class Depot::FilesController < ApplicationController


  def index
    if params[:order]
      @order = params[:order]
    else 
      @order = "created_at DESC"
    end
    @files = Depot::File.paginate(:per_page => 10, :page => params[:page], :order => @order, :conditions => ['state = ?', 'public'])
    @folders = Depot::Filefolder.find(:all, :conditions => ['state = ?', 'public'], :order => @order)
  end

  def show

    @file = Depot::File.find params[:id]
    @extension = @file.filename.to_s.scan(/\.\w+$/)
  end

  def by_tag
    @tag  =  Tag.find_by_name(params[:tag_name])
    @files = Depot::File.find_tagged_with(@tag, :conditions => ['state=?', "public"]).paginate(:per_page => 10, :page => params[:page]) unless @tag.nil?
    @folders = Depot::Filefolder.find_tagged_with(@tag, :conditions => ['state=?', "public"]) unless @tag.nil?
  end

  def download
    @file = Depot::File.find params[:id]
    @num = @file.num_download+1
    @file.update_attribute (:num_download, @num)
    send_file("public/" + @file.public_filename)
  end
	
end

