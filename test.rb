require 'rmagick'
def draw_text(font = nil, text = "", width = 100, height = 100, fn = 'font.png')
    canvas = Magick::Image.new(width,height) { self.background_color = "Blue" }
    text = text.upcase.strip
    anno = Magick::Draw.new.tap do |a|
        a.gravity = Magick::NorthWestGravity
        a.font = font if font
        a.pointsize = 15
        a.font_weight = 800
        a.fill = "red"
        a.gravity = Magick::CenterGravity
    end
    text = add_new_line(text, anno, canvas)
    anno.annotate(canvas, 0, 0, 0, 0, text)

    canvas.display
end
def add_new_line(string, anno, canvas, start_width = 0)
    arr = string.split("")
    sumw = start_width
    nlpos = []
    last_word_pos = 0
    lw = 0
    arr.each_with_index do |ele,i|
        dup = anno.dup
        dcanvas = canvas.dup
        dcanvs2 = canvas.dup
        ele = ele + arr[0] if i!=0
        dup.annotate(dcanvas, 0, 0, 0, 0, ele)
        dup.annotate(dcanvs2, 0, 0, 0, 0, ele[0])
        dcanvas.write("rmagick_temp/temp#{i}.png")
        metrics = dup.get_type_metrics(dcanvas, ele)
        dcv2 = dup.get_type_metrics(dcanvs2,ele[0]).width
        if ele == ' '
            last_word_pos = i + 1
        end
        puts ("#{sumw} #{metrics.width} #{metrics.width - lw - dcv2} #{dcanvas.columns}")
        sumw += metrics.width - lw
        if i == 0
            lw = metrics.width
        end
        if sumw >= dcanvas.columns
            nlpos << i
            sumw = 0
        end
    end
    
    nlpos.each do |ele|
        arr.insert(ele, "\n")
        p ele
    end

    p arr
    return arr.join('')
end

draw_text("","ABCDEFGHJKLOPQRSTUVWXYZMN123456789")
exit