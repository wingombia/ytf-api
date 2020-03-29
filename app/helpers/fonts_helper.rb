module FontsHelper
  MAX_LETTER_HEIGHT, MAX_FONT_SIZE = 50, 50
  MAX_LETTER_WIDTH = 30
  FILE_NAME = "font.png"

  def draw_text(options)
    options = get_default_value(options)
    canvas = get_canvas(options)
    anno = get_annotation(options)
    
    text = options[:text].strip
    text = add_new_line(text,anno,canvas)

    anno.annotate(canvas, 0, 0, 0, 0, text)
    canvas.write(FILE_NAME)
  end

  private

  def get_canvas(options)
    canvas = Magick::Image.new(options[:bg_width], options[:bg_height]) do
      self.background_color = options[:bg_color]
    end

    canvas
  end

  def get_annotation(options)
    anno = Magick::Draw.new.tap do |a|
      a.gravity = Magick::NorthWestGravity
      a.font = options[:font]
      a.pointsize = options[:size].to_f
      a.font_weight = options[:weight]
      a.fill = options[:color]
    end 
    anno
  end

  def get_default_value(options)
    options[:font]      ||= "Helvetica"
    options[:size]      ||= 12
    options[:weight]    ||= 400
    options[:color]     ||= "red"
    options[:bg_color]  ||= "Transparent"
    options[:bg_width]  ||= 500
    options[:bg_height] ||= 500
    options[:text]      ||= "Default Text"
    
    options
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
    
    chars.join('')
  end

  def width_of_char(chars, anno, index = 0)
    
    anno_dup = anno.dup
    canvas_dup = Magick::Image.new(MAX_LETTER_HEIGHT * chars.length, MAX_LETTER_WIDTH) { self.background_color = "Transparent" }

    anno_dup.annotate(canvas_dup, 0, 0, 0, 0, chars)
    metrics = anno_dup.get_type_metrics(canvas_dup, chars)

    metrics.width
  end

  def width_of_ws(anno)
    width_of_char("B A", anno) - width_of_char("A", anno) - width_of_char("B", anno)
  end
end