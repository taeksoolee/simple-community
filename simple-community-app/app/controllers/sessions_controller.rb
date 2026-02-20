class SessionsController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]

  def new
  end

  def create
    if user = User.find_by(email_address: params[:email_address])
      if user.authenticate(params[:password])
        start_new_session_for(user)
        redirect_to root_path, notice: "로그인 되었습니다"
      else
        flash.now[:alert] = "이메일 또는 비밀번호가 일치하지 않습니다"
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "이메일 또는 비밀번호가 일치하지 않습니다"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to root_path, notice: "로그아웃 되었습니다"
  end
end
