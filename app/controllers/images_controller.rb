class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy, :toggle_tag]
  before_action :set_bg_image, only: [:index, :new]
  before_action :get_bg_image, except: [:index, :new]
  before_filter :require_user, :only=>[:new, :create, :update, :edit]
  before_filter :require_mgt, :only=>[:new, :create, :update, :edit]
  
  # GET /images
  def index
    @tag = params[:tag]
    if @tag.present?
      @images = Image.tagged_with(@tag)
    else
      redirect_to root_url and return
    end
  end

  # GET /images/1
  def show
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
    @tags = @image.tag_list
  end

  # POST /images
  def create
    @image = Image.new(image_params)

    if @image.save
      redirect_to @image, notice: 'Image was successfully created.'
    else
      render :edit
    end
  end

  # PATCH/PUT /images/1
  def update
    if @image.update(image_params)
      redirect_to @image, notice: 'Image was successfully updated.'
    else
      render :edit
    end
  end

  def toggle_tag
    tag = params[:tag].try(:downcase)
    if tag.present?
      if @image.tag_list.include?(tag)
        @image.tag_list.remove(tag)
      else
        @image.tag_list.add(tag)
      end
      @image.save
    end
    render :text=>"OK"
  end

  # DELETE /images/1
  def destroy
    @image.destroy
    redirect_to images_url, notice: 'Image was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def image_params
      params.require(:image).permit(:file, :tag_list)
    end

    def set_bg_image
    end

    def get_bg_image
    end

    def require_mgt
      if !current_user.mgt?
        redirect_to root_url and return
      end
    end
end
