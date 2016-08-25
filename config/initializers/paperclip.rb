if Rails.env.development?
  Paperclip::Attachment.default_options[:url] = '/:class/:attachment/:id_partition/:style/:filename'
  Paperclip::Attachment.default_options[:path] = File.join(Rails.root, 'public','/:class/:attachment/:id_partition/:style/:filename')
else
  Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
  Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
end