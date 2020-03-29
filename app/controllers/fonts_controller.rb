class FontsController < ApplicationController
    before_action :unlock_cors
    def get
      draw_text(option_params)
      send_file "#{Rails.root}/font.png", type: "image/png"#, disposition: 'inline'
    end

    private 
     
    def option_params
      params.permit(:font, :text, :size, :color, :weight,
                    :bg_color, :bg_width, :bg_height)
    end

    def unlock_cors
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
      headers['Access-Control-Request-Method'] = '*'
      headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    end
end
