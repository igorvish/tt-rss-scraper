class Api::V0::RssFeedsController < Api::V0::BaseController

  def index
    @feeds = RssFeed.order(id: :desc)
      .page(params[:page]).per(params[:per])
    render json: @feeds, meta: pagination_meta(@feeds)
  end

  def search
    @feeds = RssFeed.basic_search(search_params)
      .page(params[:page]).per(params[:per])
    render json: @feeds, meta: pagination_meta(@feeds)
  end

  private

    def search_params
      params[:q]
    end

end
