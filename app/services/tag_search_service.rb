class TagSearchService
  attr_reader :tag, :users, :games

  def initialize(tag_id=nil)
    @games = @users = []
    @tag   = Tag.find(tag_id)
    if @tag.present?
      @games = Game.by_tag(tag_id)
      @users = User.by_tag(tag_id)  
    end
  end
end
