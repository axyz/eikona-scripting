require 'thor'
require 'imaging/commands'
require 'imaging/workflow'

module Imaging
    class CLI < Thor

        desc "weblarge [path]", "create a web-large directory in [path] with 3000x2000 resized images and the watermark versions"
        def weblarge(path)
            Workflow.web_large(path)
        end

        desc "resize [WIDTHxHEIGHT] [--watermark type] [path]", "create subfolder named as [WIDTHxHEIGHT] and put inside resized images"
        option :watermark
        def resize(path, size="3000x2000")
           Commands.resize_in(path, size, size, 90)
           if options[:watermark] then
               Dir.chdir path
               Dir.chdir size
               Commands.ls_img(".").each { |img| Commands.watermark(options[:watermark].to_sym, img) }
           end
        end

    end
end
