class UsersController < ApplicationController

  skip_before_action :verify_authenticity_token, only: :update

  def update
    current_user.update_attributes!(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:role, :country_name)
  end

end
