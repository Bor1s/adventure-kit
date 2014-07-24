class Master::HeatmapController < Master::BaseController
  respond_to :html, :js

  def index
    @service = GamesHeatmapService.new
    respond_with do |format|
      format.html
      format.js do
        render json: {data: @service.data,
                      title: I18n.t('general.games_heatmap'),
                      days: I18n.t('general.day_names')}
      end
    end
  end
end
