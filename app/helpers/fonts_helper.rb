module FontsHelper
    MAX_SIZE = 50
    def draw_text(font = nil, text = "", size = 12, width = 500, height = 500, fn = 'font.png')
        canvas = Magick::Image.new(width,height) { self.background_color = "Transparent" }
        
        text = text.upcase.strip

        anno = Magick::Draw.new.tap do |a|
            a.gravity = Magick::NorthWestGravity
            a.font = font if font
            a.pointsize = size.to_f
            a.font_weight = 800
            a.fill = "red"
        end
        #fn = "font#{size}.png"
        text = add_new_line(text, anno, canvas, 0)

        anno.annotate(canvas, 0, 0, 0, 0, text)

        canvas.write(fn)
    end

    def add_new_line(text, anno, canvas, start_width = 0)
        chars = text.split("")
        sum_width = start_width
        new_line_pos = []
        last_word_pos = 0
        width_since_last_space = 0
        space_width = width_of_ws(anno)
        padding_right = 10

        chars.each_with_index do |char,i|
            woc = width_of_char(char, anno)
            sum_width += woc
            width_since_last_space += woc

            if char == ' '
                last_word_pos = i
                width_since_last_space = space_width
            end

            if sum_width >= canvas.columns - padding_right 
                new_line_pos << last_word_pos
                sum_width = width_since_last_space
            end
        end
        
        new_line_pos.each do |pos|
            chars[pos] = "\n"
        end
        
        return chars.join('')
    end
    
    def width_of_char(char, anno, index = 0)
        if char == ' '
            return 0
        end
        anno_dup = anno.dup
        canvas_dup = Magick::Image.new(MAX_SIZE, 30) { self.background_color = "Transparent" }
        fixed_width = 0
        #if index != 1
        #   char = char + 'A'
        #    fixed_width = width_of_char('A', anno, 1)
        #end
        anno_dup.annotate(canvas_dup, 0, 0, 0, 0, char)
        metrics = anno_dup.get_type_metrics(canvas_dup, char)
        
        return metrics.width - fixed_width
    end

    def width_of_ws(anno)
        return width_of_char("B A", anno) - width_of_char("A", anno) - width_of_char("B", anno)
    end
end