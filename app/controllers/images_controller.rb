class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy, :toggle_tag, :add_tag, :toggle_match]
  before_filter :require_user, :except=>[:show, :index]
  before_filter :require_mgt, :except=>[:show, :index]
  before_filter :choose_bg, :only=>[:index]
  protect_from_forgery :except => [:delete]
  skip_before_filter :verify_authenticity_token, :only=>[:destroy, :create]

  def toggle_match
    if match = Image.find_by_id(params[:match_id])
      if @image.matched_images.include?(match)
        @image.matched_images.delete(match)
      else
        @image.matched_images << match
      end
    end
    redirect_to edit_image_path(@image)
  end

  def add_tag
    tag = params[:tag].try(:downcase)
    if tag.present?
      @image.tag_list.add(tag)
      @image.save
    end
    redirect_to edit_image_path(@image)
  end
  
  # GET /images
  def index
    if @tag.present?
      @images = Image.tagged_with(@tag)
    else
      @tag = []
      @images = Image.all
    end
    @images = @images.to_a.shuffle
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
    @image = Image.new({:file=>params[:file]})

    if @image.save
      render :json=>{:redirect_to=> edit_image_path(@image)}
    else
      render :new
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
    redirect_to root_url, notice: 'Image was successfully destroyed.'
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

    def choose_bg
      @tag = params[:tag]
      @tag = [@tag] if @tag.is_a?(String)
      set_bg("moon")
      set_bg("saturn") if tags_in ["saturn","hotaru","pluto","setsuna"]
      set_bg("uranus") if  tags_in ["haruka","uranus"]
      set_bg("neptune") if tags_in ["michiru","neptune"]
      set_bg("tux") if tags_in ["tux"]
      set_bg("pink") if tags_in ["chibiusa","chibimoon"]
      set_bg("red") if tags_in ["mars","rei"]
      set_bg("yellow") if tags_in ["venus","minako"]
      set_bg("blue") if tags_in ["mercury","ami"]
      set_bg("green") if tags_in ["jupiter","makoto"]
      set_bg("moon2") if tags_in ["moon","usagi","super sailor moon"]
    end

    def tags_in arr
      return false unless @tag
      arr.each do |a|
        return true if @tag.downcase.include?(a)
      end
      false
    end

    def require_mgt
      if !current_user.mgt?
        redirect_to root_url and return
      end
    end
end
