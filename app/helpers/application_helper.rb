module ApplicationHelper
  def vk_login_link
    link_to image_tag(asset_path('vk_logo.jpg'), alt: 'Sign In via VK'), '/auth/vkontakte', class: 'thumbnail'
  end

  def allowed_to_administrate?
    can? :manage, :all
  end

  def admin_sidepanel
    case controller_name
    when 'genres'
      content_tag :div do
        link_to new_genre_path, class: 'btn btn-success' do
          content_tag :i, ' Genre', class: 'fa fa-plus'
        end
      end.html_safe
    end
  end

  def regular_sidepanel
    content_tag :div, 'Your dashboard'
  end
end
