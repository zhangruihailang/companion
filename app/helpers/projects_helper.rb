module ProjectsHelper
  def project_attachments_tag(attachment, options = {})
    options[:style] ||= :small
    style = case options[:style].to_s
    when "small" then "60x60"
    when "normal" then "200x200"
    when "large" then "400x400"
    #when "tiny" then "20x20"
    else options[:style].to_s
    end
    link_to image_tag(attachment.file(style)), attachment
  end
end
