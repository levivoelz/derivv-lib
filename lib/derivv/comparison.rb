require 'mini_magick'

class Comparison
  
  def initialize(original, compressed)
    @original = original
    @compressed = compressed
  end
  
  def difference
    compare = MiniMagick::Tool::Compare.new(false)

    compare.metric("AE")
    compare.fuzz("10%")
    compare << @original
    compare << @compressed
    compare << "null:"

    output = capture_stderr do
      compare.call
    end
    
    output.to_i
  end
  
  def acceptable?
    threshold = 15
    
    difference < threshold ? true : false
  end
  
  private
  
  def capture_stderr
    $stderr = StringIO.new
    yield
    output = $stderr.string
    $stderr = STDERR

    output
  end
  
end