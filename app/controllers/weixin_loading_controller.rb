class WeixinLoadingController < ApplicationController
  skip_before_filter :verify_authenticity_token
  layout "loading", :only => :show
 
  
  def show
    render "loading"
  end
  
  def goto
    goto = params[:redirect_page]
    p "-------------------------------goto:/#{goto}----------------------------------"
    render text: "/#{goto}"
    # respond_to do |format|
    #   format.html { 
    #     render "/projects/index" 
    #     return
        
    #   }
    # end
  end
  
end
