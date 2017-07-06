module Spree
  class EventImage < Asset

    has_attached_file :attachment,
                      styles: {web_banner: '1200x516#', cover: '1200x516#', small: '384x165#'},
                      default_style: :cover,
                      convert_options: {all: '-strip -auto-orient -colorspace sRGB -interlace Plane -quality 80'}

    validate :no_attachment_errors
    validates_attachment :attachment,
      presence: true,
      content_type: { content_type: %w(image/jpeg image/jpg image/png image/gif) }

    # save the w,h of the original image (from which others can be calculated)
    # we need to look at the write-queue for images which have not been saved yet
    before_save :find_dimensions

    #used by admin products autocomplete
    def mini_url
      attachment.url(:mini, false)
    end

    def find_dimensions
      temporary = attachment.queued_for_write[:original]
      filename = temporary.path unless temporary.nil?
      filename = attachment.path if filename.blank?
      geometry = Paperclip::Geometry.from_file(filename)
      self.attachment_width  = geometry.width
      self.attachment_height = geometry.height
    end

    # if there are errors from the plugin, then add a more meaningful message
    def no_attachment_errors
      unless attachment.errors.empty?
        # uncomment this to get rid of the less-than-useful interim messages
        # errors.clear
        errors.add :attachment, "Paperclip returned errors for file '#{attachment_file_name}' - check ImageMagick installation or image source file."
        false
      end
    end
  end
end