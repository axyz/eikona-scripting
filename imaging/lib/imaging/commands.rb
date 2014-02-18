require 'digest'

module Imaging
    module Commands
        HOME = Dir.home
        MOGRIFY = "/opt/ImageMagick/bin/mogrify"
        CONVERT = "/opt/ImageMagick/bin/convert"
        SRGB = "#{HOME}/icc/sRGB.icc"
        FILTER = "lanczos -define filter:lobes=8"
        WATERMARK = {
                        :big => {
                            :path => 'watermark.jpg',
                            :gravity => 'south',
                            :scale => 1,
                            :x_rel_offset => 0,
                            :y_rel_offset => 0.1459,
                            :compose_method => 'hardlight'
                        },
                        :small => {
                            :path => 'watermark-small.jpg',
                            :gravity => 'SouthWest',
                            :scale => 0.3,
                            :x_rel_offset => 0,
                            :y_rel_offset => 0,
                            :compose_method => 'hardlight'
                        }
                    }

        def self.get_random_postfix
            Digest::MD5.hexdigest(Time.now.to_s)[1,4]
        end

        def self.ls_img(path)
            Dir.entries(path).select { |x| x =~ /(.jpg)|(.JPG)|(.tif)|(.TIF)|(.tiff)|(.TIFF)|(.jpeg)|(.JPEG)/ }
        end

        def self.get_h(path)
            `convert '#{path}' -format "%h" info:`.sub("\n", "").to_i 
        end

        def self.get_w(path)
            `convert '#{path}' -format "%w" info:`.sub("\n", "").to_i
        end

        def self.resize(path, size, compression)
            `#{MOGRIFY} -profile '#{SRGB}' -filter #{FILTER} -resize #{size} -format jpg -quality #{compression} -sampling-factor 4:4:4 -interlace line -density 72 #{path}`
        end

        def self.watermark(type, path)
            `#{CONVERT} '#{HOME}/#{WATERMARK[type][:path]}' -resize #{get_w(path)*WATERMARK[type][:scale]} miff:- | convert -compose #{WATERMARK[type][:compose_method]} -composite -geometry +#{(get_w(path)*WATERMARK[type][:x_rel_offset]).to_i}+#{(get_h(path)*WATERMARK[type][:y_rel_offset]).to_i} -gravity #{WATERMARK[type][:gravity]} '#{path}' - -set filename:orig %t wm-%[filename:orig].jpg`
        end

        def self.resize_in(orig, dest, size, compression)
            Dir.chdir orig
            FileUtils.mkdir_p dest
            ls_img(".").each { |img| `cp #{img} #{dest}` }
            Dir.chdir dest
            ls_img(".").each { |img| resize(img, size, compression) }
            Dir.chdir ".."
            Dir.chdir ".."
        end
    end
end
