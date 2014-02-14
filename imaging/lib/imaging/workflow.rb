require 'imaging/commands'

module Imaging
    module Workflow
        def self.web_large(path)
            Commands.resize_in(path, "web-large", "3000x2000", 90)
            Dir.chdir path
            Dir.chdir "web-large"
            Commands.ls_img(".").each { |img| Commands.watermark(:big, img) }
        end
        
        def self.web_medium(path, wm_type)
            Commands.resize_in(path, "web-medium", "1280x1024", 90)
            Dir.chdir path
            Dir.chdir "web-medium"
            Commands.ls_img(".").each { |img| Commands.watermark(wm_type, img) }
        end
        
        def self.web_small(path)
            Commands.resize_in(path, "web-small", "990x660", 90)
            Dir.chdir path
            Dir.chdir "web-small"
            Commands.ls_img(".").each { |img| Commands.watermark(:big, img) }
        end

    end
end
