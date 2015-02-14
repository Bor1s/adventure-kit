class Master::GamesController < Master::BaseController
  respond_to :json

  def index
    @games = current_user.games
    render json: @games
  end

  def destroy
    @game = Game.find params[:id]
    authorize! :destroy, @game
    @game.destroy
    render json: {success: true}
  end
end
