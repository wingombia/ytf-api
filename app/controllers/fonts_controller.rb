class FontsController < ApplicationController
    def get
      draw_text(option_params)
      send_file "#{Rails.root}/font.png", type: "image/png"#, disposition: 'inline'
    end

    private 
     
    def option_params
      params.permit(:font, :text, :size, :color, :weight,
                    :bg_color, :bg_width, :bg_height)
    end
end
