class Image < ActiveRecord::Base
    acts_as_taggable
    has_attached_file :file, 
      styles: { thumb: "200x200>" }, 
      default_url: "/missing.png",
      storage: Rails.env.production? ? "s3" : "filesystem"
    validates_attachment_content_type :file, :content_type => /\Aimage\/.*\Z/
    has_many :matches
    has_many :matched_images, :through=>:matches, :dependent=>:destroy
    PLANETS = ["Moon", "Mercury", "Mars", "Jupiter", "Venus", "ChibiMoon", "Pluto", "Saturn", "Uranus", "Neptune", "Sailor StarMaker","Sailor StarHealer", "Sailor StarFighter","Chibichibi","Princess Fireball","Galaxia"]
    GIRLS =  ["Usagi", "Ami", "Rei", "Makoto", "Minako", "ChibiUsa", "Setsuna", "Hotaru", "Haruka", "Michiru"]
    before_save :calculate_num_girls

    def self.save_old_file_paths
      Image.all.each do |image|
        image.update_attribute(:old_file_path,image.file.path)
      end
    end

    def move
      (self.file.styles.keys+[:original]).each do |style|
        old = old_file_path.gsub("original",style.to_s)
        if Rails.env.development?
          if File.exists?(old)
            FileUtils.move(old, self.file.path(style)) 
          end
        else
        
          AWS::S3::S3Object.move_to old, self.file.path(style), self.file.bucket_name
        end

        self.update_attribute(:file_file_name, "#{style}#{File.extname(old_file_path)}")
      end
    end

    def calculate_num_girls
      girls = []
      self.tag_list.each do |tag|
        if tag.downcase.include?("girl")
         self.tag_list.remove(tag)
        end
      end
      PLANETS.each_index do |i|
        self.tag_list.each do |tag|
            if tag.downcase.in?([GIRLS[i].try(:downcase), PLANETS[i].downcase])
                girls[i]=true
                puts tag
            end
        end
      end
      girls = girls.compact.length
      if girls == 1
        self.tag_list << "1 girl"
      elsif girls > 0
        self.tag_list << "#{girls} girls"
      end
    end

    #when "Usagi" tag is added, add "Moon" tag too
    def add_identity
      GIRLS.each_index do |i|
        girl = GIRLS[i].downcase
        if tag_list.downcase.include?(girl)
            self.tag_list << PLANETS[i]
        end
      end
    end
end
