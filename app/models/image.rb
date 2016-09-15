require 'aws-sdk'
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
    before_save :calculate_num_girls, :combotags

    # def self.save_old_file_paths
    #   Image.all.each do |image|
    #     image.update_attribute(:old_file_path,image.file.path)
    #   end
    # end

    # def move
    #   Aws.config.update({credentials: Aws::Credentials.new(ENV.fetch('S3_KEY'), ENV.fetch('S3_SECRET'))})
    #   s3 = Aws::S3::Resource.new(region: 'us-east-1')
    #   my_bucket = s3.bucket("hires-prod")
    #   (self.file.styles.keys+[:original]).each do |style|
    #     old = old_file_path.gsub("original",style.to_s)
    #     if Rails.env.development?
    #       if File.exists?(old)
    #         FileUtils.move(old, self.file.path(style)) 
    #       end
    #     else
    #       old = i.old_file_path.gsub("/images","images").gsub("original",style.to_s)
    #       path = i.file.path.gsub("/images","images").gsub("original",style.to_s)
    #       my_bucket.object(old).move_to({:bucket=>i.file.bucket_name, :key=>path, :acl=>:public_read}) rescue nil
    #       x=Aws::S3::ObjectAcl.new(:bucket_name=>i.file.bucket_name, :object_key=>path, :region=>'us-east-1')
    #       x.put({acl:"public-read"})
    #     end
    #   end
    #   self.update_attribute(:file_file_name, "#{style}#{File.extname(self.old_file_path)}")
    # end

    def self.update_acl image_id
      i = Image.find image_id
      @config ||= Aws.config.update({credentials: Aws::Credentials.new(ENV.fetch('S3_KEY'), ENV.fetch('S3_SECRET'))})
      [:thumb, :original].each do |style|
        path = i.file.path.gsub("/images","images").gsub("original",style.to_s)
        Aws::S3::ObjectAcl.new(:bucket_name=>i.file.bucket_name, :object_key=>path, :region=>'us-east-1').put({acl:"public-read"})
      end
    end

    def calculate_num_girls
      girls = []
      self.tag_list.each do |tag|
        if tag.downcase.include?("girl")
         self.tag_list.remove(tag)
        end
      end
      return if self.tag_list.downcase.include?("villains")
      return if self.tag_list.downcase.include?("others")
      PLANETS.each_index do |i|
        self.tag_list.each do |tag|
            next if tag.include?("+")
            if tag.downcase.in?([GIRLS[i].try(:downcase), PLANETS[i].downcase])
                girls[i]=true
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

    def combotags #Add "Mars+Rei" if Rei or Mars is tagged
      self.tag_list.each do |tag|
        if tag.include?("|")
         self.tag_list.remove(tag)
        end
      end  
      self.tag_list.each do |tag|
        if tag.include?("+")
         self.tag_list.remove(tag)
        end
      end  
      GIRLS.each_index do |g|
        girl = GIRLS[g]
        planet = PLANETS[g]
        if girl.downcase.in?(self.tag_list.downcase) || planet.downcase.in?(self.tag_list.downcase) 
          self.tag_list << "#{planet}+#{girl}"
        end
      end
    end

end
