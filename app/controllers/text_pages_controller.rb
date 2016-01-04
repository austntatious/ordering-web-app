#
# controller to show arbitrary text pages
#
class TextPagesController < ApplicationController
  respond_to :js, :html

  def show
    @text_page = TextPage.find_by_url(params[:url])
    if @text_page.nil?
      TextPage.find(-1)
    end
  end
end

