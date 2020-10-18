class UsersController < ApplicationController
  # GET /users/:id
  
  def show
    @user = User.find(params[:id])
    
  end
  
  #POST /users/new
  def new
    @user = User.new

  end
  
  #POST /users (+ params)
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user

      flash[:success] = "Welcom to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  #private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
  def destroy
    log_out
    redirect_to root_url
  end
end
