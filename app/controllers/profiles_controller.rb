# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :load_profile, only: %i[show edit update]
  before_action :authorize_user!, only: %i[edit update]

  def show; end

  def edit; end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path(@profile), notice: 'Profile was successfully updated.'
    else
      render 'edit', notice: 'Profile was not updated.'
    end
  end

  private

  def load_profile
    @profile = Profile.find(params[:id])
  end

  def profile_params
    params.require(:profile).permit(:name)
  end

  def authorize_user!
    return if current_user == @profile.user

    head :forbidden
  end
end
