require './imaging'

module Eikona
    module Workflow
        def self.web_large(path)
            Imaging.resize_in(path, "web-large", "3000x2000", 90)
            Dir.chdir path
            Dir.chdir "web-large"
            Imaging.ls_img(".").each { |img| Imaging.watermark(:big, img) }
        end
        
        def self.web_medium(path)
            Imaging.resize_in(path, "web-medium", "1280x1024", 90)
            Dir.chdir path
            Dir.chdir "web-medium"
            Imaging.ls_img(".").each { |img| Imaging.watermark(:big, img) }
        end
        
        def self.web_small(path)
            Imaging.resize_in(path, "web-small", "990x660", 90)
            Dir.chdir path
            Dir.chdir "web-small"
            Imaging.ls_img(".").each { |img| Imaging.watermark(:big, img) }
        end

    end
end
