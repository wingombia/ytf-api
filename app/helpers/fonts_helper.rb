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
        word = ''
    
        chars.each_with_index do |char,i|
            if char != ' '
                word = word + char
                next if i < chars.length - 1
            end

            woc = width_of_char(word, anno)
            sum_width += woc 
            sum_width += space_width if i < chars.length - 1

            word = ''

            if sum_width >= canvas.columns
                new_line_pos << last_word_pos
                sum_width = woc
            end

            last_word_pos = i if char == ' '
        end
        
        new_line_pos.each do |pos|
            chars[pos] = "\n"
        end
        
        return chars.join('')
    end
    
    def width_of_char(char, anno, index = 0)
        
        anno_dup = anno.dup
        canvas_dup = Magick::Image.new(MAX_SIZE * char.length, 30) { self.background_color = "Transparent" }

        anno_dup.annotate(canvas_dup, 0, 0, 0, 0, char)
        metrics = anno_dup.get_type_metrics(canvas_dup, char)
    
        return metrics.width
    end

    def width_of_ws(anno)
        return width_of_char("B A", anno) - width_of_char("A", anno) - width_of_char("B", anno)
    end
end