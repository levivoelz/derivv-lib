class Size
  attr_reader :width, :height
  
  def initialize(width, height)
    @width = width
    @height = height
  end
  
  def dimensions
    "#{@width}x#{@height}"
  end
end