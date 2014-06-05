class Player::BaseController < ApplicationController
  layout 'player'
  respond_to :html
  before_action :authenticate, :verify_player

  private

  def verify_player
    redirect_to root_path unless current_user.player?
  end
end
