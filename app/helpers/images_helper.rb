module ImagesHelper
  def toggle_tag tag
    tag_class = @tags.include?(tag.downcase) ? "tagged" : ""
    link_to tag, toggle_tag_image_path(@image, :tag=>tag), :class=>tag_class
  end

  def sailors
    %w(Moon Mercury Mars Jupiter Venus Chibi Pluto Uranus Neptune Saturn)
  end

  def girls
    %w(Usagi Ami Rei Makoto Minako Chibiusa Setsuna Haruka Michiru Hotaru)
  end

  def seasons
    ["Sailormoon","Sailormoon R","Sailormoon S","Sailormoon SuperS","Sailormoon SailorStars","Movies"]
  end

  def media
    ["90s anime","manga","bookmark"]
  end

  def other_tags
    ActsAsTaggableOn::Tag.most_used(50)
  end


end
