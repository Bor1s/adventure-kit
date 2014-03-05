class TagsController < ApplicationController
  before_action :authenticate
  respond_to :html

  def index
    @tags = Tag.page(params[:page])
    respond_with @tags do |format|
      format.html
      format.json do
        #TODO Maybe restrict amount of output tags?
        render json: Tag.search(params[:q]).tokenize
      end
    end
  end
end
