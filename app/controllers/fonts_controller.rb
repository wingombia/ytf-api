class FontsController < ApplicationController
    before_action :unlock_cors
    def get
        if !(params[:text] && params[:font])
            return render json: { errors: "no text and/or font params" }, status: :unprocessable_entity
        end

        draw_text(params[:font], params[:text], params[:size])
        #send_file "#{Rails.root}/font.png", type: "image/png"#, disposition: 'inline'
        render json: {url: "#{Rails.root}/font.png"}
    end
    private 
     def unlock_cors
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
        headers['Access-Control-Request-Method'] = '*'
        headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
     end
end
