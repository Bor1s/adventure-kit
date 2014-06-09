class TagsController < ApplicationController
  before_action :authenticate
  respond_to :html

  def index
    respond_with do |format|
      format.html do
        @tags = Tag.search(params[:q]).asc(:title).page(params[:page])
      end
      format.json do
        render json: Tag.search(params[:q]).tokenize
      end
    end
  end

  def search
    service = TagSearchService.new(params[:tag_id])
    @users = service.users
    @games = service.games
    @tag   = service.tag
  end

  def edit
    @tag = Tag.find(params[:id])
    authorize! :update, @tag
  end

  def update
    @tag = Tag.find(params[:id])
    authorize! :update, @tag
    @tag.last_edited_by = current_user.id
    @tag.update_attributes(tag_attributes)
    respond_with @tag, location: tags_path
  end

  def destroy
    @tag = Tag.find(params[:id])
    authorize! :destroy, @tag
    @tag.destroy
    respond_with @tag
  end

  private

  def tag_attributes
    params.require(:tag).permit(:title, :description)
  end
end
