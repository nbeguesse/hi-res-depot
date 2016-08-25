class Image < ActiveRecord::Base
    acts_as_taggable
    has_attached_file :file, 
      styles: { thumb: "200x200>" }, 
      default_url: "/images/:style/missing.png",
      storage: Rails.env.production? ? "s3" : "filesystem"
    validates_attachment_content_type :file, :content_type => /\Aimage\/.*\Z/
end
