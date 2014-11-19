require 'derivv/size'
require 'derivv/image'
require 'derivv/comparison'



# # threshold = 50
# original = Image.new("flowers.jpg")
# resized = Image.new(original.resize("250x250", "original"))
# #compressed = Image.new(resized.compress("80"))
# compressed = Image.new(resized.compress(85))
#
# comparison = Comparison.new(resized.file, compressed.file)
#
# def get_optimally_compressed(image, quality)
#   original = image
#   image = Image.new(image.compress(quality))
#
#   comparison = Comparison.new(original.file, image.file)
#
#   if comparison.acceptable?
#     image
#   else
#     # if comparison.difference > 10 # (if diff is really high, bump up a big number)
#                                     # trying to guess the next best quality level to compress at
#     puts "re-compressing at #{quality + 1}"
#     get_optimally_compressed(original, quality + 1)
#   end
# end
#
# optimal = get_optimally_compressed(original, 50)
#
# puts optimal.filesize
# puts original.filesize

#
# if comparison.acceptable?
#   puts "This image is acceptible"
# else
#   puts "Image compression is too high, please recompress at a lower level"
# end
# arr = []
# resized = Image.new(image.resize("500x500", "original"))
# resized2 = Image.new(image.resize("200x200", "original"))
#
# arr << resized.filesize
# arr <<  resized2.filesize
# puts arr.min
#
# size = Size.new(500, 200)
# puts [size.width, size.height].min
#
