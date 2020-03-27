require 'RMagick'
text = "test!"
canvas = Magick::Image.new(100,100) { self.background_color = 'red' }
anno = Magick::Draw.new.tap do |t|
    t.gravity = Magick::CenterGravity
end

anno.annotate(canvas, 0, 0, 0, 0, text)

p canvas.to_blob