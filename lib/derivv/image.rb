require 'mini_magick'
require 'derivv/size'
require 'derivv/comparison'

class Image
  attr_reader :file, :basename, :ext, :image
  attr_accessor :format, :name
  
  def initialize(file, options={})
    @file = file
    @basename = File.basename(@file, File.extname(@file))
    @ext = File.extname(@file).downcase
    @image = MiniMagick::Image.open(@file)
    @name = @basename
    @format = @ext.gsub(".", "")
  end

  def colors
    identify = MiniMagick::Tool::Identify.new
    
    identify.format("'%k'")
    identify << @file
    
    identify.call[/-?\d+/].to_i
  end
  
  def alpha?
    if format === "png"
      convert = MiniMagick::Tool::Convert.new
    
      convert << @file
      convert.format("'%[opaque]'")
      convert << "info:"
    
      # Return the opposite
      !!convert.call
    else
      false
    end
  end
  
  def filesize
    shell = MiniMagick::Shell.new
    
    shell.run(["wc", "-c", @file]).match(/\d+/)[0].to_i
  end

  def pixels
    convert = MiniMagick::Tool::Convert.new
    
    convert << @file
    convert.format("'%[fx:w*h]'")
    convert << "info:"

    convert.call
  end
  
  def suggested_format
    if alpha?
      "png"
    elsif colors < 8**4 # could use along with other methods like pixel density
      "png"
    else
      "jpg"
    end
  end
  
  # 
  # Actions
  #
  
  def resize(size, format)
    format = @ext if format == "original"
    new_name = "#{@basename}_#{size}#{format}"

    @image.combine_options do |b|
      b.resize size # ex: "500x500"
    end

    @image.write(new_name)
    
    if File.exists?(new_name)
      new_name
    else
      raise "The image wasn't resized and saved for some reason."
    end
  end
  
  def compress(qual)
    new_name = "#{@basename}_compressed#{@ext}"
    compress = MiniMagick::Tool::Convert.new
    
    compress << @file
    compress.quality(qual)
    compress << new_name
    
    compress.call
    
    if File.exists?(new_name)
      new_name
    else
      raise "The image wasn't compressed and saved for some reason."
    end
  end
  
  def smart_compress(qual)
    original = @image
    @image = Image.new(@image.compress(qual))

    comparison = Comparison.new(original.file, @image.file)

    if comparison.acceptable?
      @image
    else
      # if comparison.difference > 10 
      # (if diff is really high, bump up a big number)
      # trying to guess the next best quality level to compress at
      puts "re-compressing at #{qual + 1}"
      smart_compress(original, qual + 1)
    end
  end
  
end