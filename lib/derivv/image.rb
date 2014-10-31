class Image
  attr_reader :file
  
  def initialize(file)
    @file = file
    @basename = File.basename(@file, File.extname(@file))
    @ext = File.extname(@file)
    @image = MiniMagick::Image.open(file)
  end

  def resize(size, format)
    
    # size ||= [size]
    
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
  
end