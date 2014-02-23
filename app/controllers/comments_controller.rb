class CommentsController < ApplicationController
  before_action :authenticate, :load_game
  respond_to :html, :js

  def create
    authorize! :create, Comment
    @comment = @game.comments.build(comment_params)
    @comment.user = current_user
    @comment.save
  end

  def edit
    @comment = @game.comments.find(params[:id])
    authorize! :update, @comment
  end

  def update
    @comment = @game.comments.find(params[:id])
    authorize! :update, @comment
    @comment.update_attributes(comment_params)
    respond_with @game, @comment
  end

  def destroy
    @comment = @game.comments.find(params[:id])
    authorize! :destroy, @comment
    @comment.destroy
  end

  private

  def load_game
    @game = Game.find(params[:game_id])
  end

  def comment_params
    params.require(:comment).permit(:message)
  end
end
