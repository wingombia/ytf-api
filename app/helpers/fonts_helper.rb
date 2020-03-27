module FontsHelper
    def draw_text(font = nil, text = "", width = 100, height = 100, fn = 'font.png')
        canvas = Magick::Image.new(width,height) { self.background_color = "Transparent" }
        text.upcase!
        anno = Magick::Draw.new.tap do |a|
            a.gravity = Magick::CenterGravity
            a.font = font if font
            a.pointsize = 20
            a.font_weight = 800
        end

        anno.annotate(canvas, 0, 0, 0, 0, text)

        canvas.write(fn)
    end
end