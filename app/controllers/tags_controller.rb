class TagsController < ApplicationController
  before_action :authenticate
  respond_to :html

  def index
    @tags = Tag.desc(:game_ids).page(params[:page])
    respond_with @tags do |format|
      format.html
      format.json do
        render json: Tag.search(params[:q]).tokenize
      end
    end
  end
end
