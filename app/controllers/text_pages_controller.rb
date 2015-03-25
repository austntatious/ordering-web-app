class TextPagesController < InheritedResources::Base
  respond_to :js, :html

  def show
    @text_page = TextPage.find_by_url(params[:url])
  end
end

