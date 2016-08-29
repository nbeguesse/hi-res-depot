module ImagesHelper
  def toggle_tag tag
    tag_class = @tags.include?(tag.downcase) ? "tagged" : ""
    link_to tag, toggle_tag_image_path(@image, :tag=>tag), :class=>tag_class
  end

  def sailors
    %w(Moon Mercury Mars Jupiter Venus ChibiMoon Pluto Uranus Neptune Saturn)
  end

  def girls
    %w(Usagi Ami Rei Makoto Minako Chibiusa Setsuna Haruka Michiru Hotaru)
  end

  def seasons
    ["Sailormoon","Sailormoon R","Sailormoon S","Sailormoon SuperS","Sailormoon SailorStars","Movies"]
  end

  def media
    ["90s anime","Manga","Bookmark","Laser Disc","CD","Calendar","Trading Card"]
  end

  def all_tags
    ActsAsTaggableOn::Tag.most_used(100)
  end

  def num_girls
    ["Alone"]+(1..10).map{|i| pluralize(i, "Girl")}
  end

  def other_heroes
    ["Tux","Luna","Artemis","Villains","Super Sailor Moon","Eternal Sailor Moon","Prism","opening","attack","henshin"]
  end

  def base_tags_for_edit
    (sailors+girls+seasons+media+other_heroes)
  end

  def base_tags_for_index
    (sailors)
  end

end
