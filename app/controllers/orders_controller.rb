class OrdersController < ApplicationController
  def new
     @project = Project.find(params[:project_id])
    @order = Order.new
    #render new_order_path
  end

  def create
   if current_user.authenticate(params[:password])
      @order = Order.new(order_params)
      project = Project.find(params[:order][:project_id])
      amount = params[:order][:amount]
      if amount.to_i.to_s == amount#amount.to_i.is_a?(Integer) 
        if amount.to_i%100==0
          income = (amount.to_i * project.yield_yearly.to_f) / 100
          #p "--------------------income=#{income}----------------------------------------------------"
          @order.income = income
          if @order.save
            redirect_to '/myFunds'
          else
            #flash[:danger] = "提交失败，请重新提交."
            #redirect_to "/orders/new?project_id=#{params[:order][:project_id]}"
            #render new_order_path(project_id: params[:order][:project_id])
            
            #@errors =  @order.errors.full_messages
           
            @project = Project.find(params[:order][:project_id])
            #@order = Order.new
            
            render 'new'
          end
        else
            flash[:danger] = "金额必须为100的倍数"
          redirect_to "/orders/new?project_id=#{params[:order][:project_id]}"
        end
        
      else
        flash[:danger] = "金额必须为数字"
        redirect_to "/orders/new?project_id=#{params[:order][:project_id]}"
      end
      
    else
      flash[:danger] = "密码不正确."
      redirect_to "/orders/new?project_id=#{params[:order][:project_id]}"
    end
    
    
  end
  
  private
  
    def order_params
      params.require(:order).permit(:project_id, :user_id, :password,
                      :amount,:income,:has_payed)
    end
end
