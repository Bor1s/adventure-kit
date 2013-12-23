module MastersHelper
  def genres_tags(genres)
    tags = genres.map do |g|
      content_tag :div, class: 'genre-tag' do
        link_to g.title, g
      end
    end
    tags.join.html_safe
  end
end
