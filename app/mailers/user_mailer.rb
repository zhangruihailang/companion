class UserMailer < ApplicationMailer

  
  
  default from: "noreply@example.com"
  
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def password_reset(user)
    @user = user
    puts "reset_token = #{@user.reset_token}"
    mail to: user.email, subject: "Password reset"
  end
 
end
