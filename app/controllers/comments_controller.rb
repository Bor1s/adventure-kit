class CommentsController < ApplicationController
  before_action :authenticate, :load_game
  respond_to :html

  def create
    @comment = @game.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to game_path(@game)
    else
      render 'games/show'
    end
  end

  def update
    #TODO
  end

  def destroy
    #TODO
  end

  private

  def load_game
    @game = Game.find(params[:game_id])
  end

  def comment_params
    params.require(:comment).permit(:message)
  end
end
