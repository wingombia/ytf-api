class FontsController < ApplicationController
    def get
        if !(params[:text] && params[:font])
            return render json: { errors: "no text and/or font params" }, status: :unprocessable_entity
        end

        draw_text(params[:font], params[:text])
        send_file "#{Rails.root}/font.png", type: "image/png"
        
    end

end
