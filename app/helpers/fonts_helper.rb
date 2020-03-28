module FontsHelper
    def draw_text(font = nil, text = "", width = 100, height = 100, fn = 'font.png')
        canvas = Magick::Image.new(width,height) { self.background_color = "Transparent" }
        
        text = text.upcase.strip

        anno = Magick::Draw.new.tap do |a|
            a.gravity = Magick::NorthWestGravity
            a.font = font if font
            a.pointsize = 15
            a.font_weight = 800
            a.fill = "red"
        end

        text = add_new_line(text,anno,canvas)

        anno.annotate(canvas, 0, 0, 0, 0, text)

        canvas.write(fn)
    end

    def add_new_line(text, anno, canvas, start_width = 0)
        chars = text.split("")
        sum_width = start_width
        new_line_pos = []
        last_word_pos = 0

        chars.each_with_index do |char,i|
            sum_width += width_of_char(char, anno, canvas, i)

            if sum_width >= canvas.columns
                new_line_pos << i
                sum_width = 0
            end
        end
        
        new_line_pos.each do |pos|
            chars.insert(pos, "\n")
        end
    
        return chars.join('')
    end
    
    def width_of_char(char, anno, canvas, index)
        anno_dup = anno.dup
        canvas_dup = canvas.dup
        fixed_width = 0
        if index != -1
            char = char + 'A'
            fixed_width = width_of_char('A', anno, canvas, -1)
        end
        anno_dup.annotate(canvas_dup, 0, 0, 0, 0, char)
        canvas_dup.write("#{Rails.root}/rmagick_temp/temp#{index}.png")
        
        #last_word_pos = i + 1 if char = ' '
        
        metrics = anno_dup.get_type_metrics(canvas_dup, char)
        
        return metrics.width - fixed_width
    end
end