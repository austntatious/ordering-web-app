class Admin::TextPagesController < AdminController
  before_action :set_text_page, only: [ :edit, :destroy, :update ]
  def index
    @text_pages = TextPage.search(params[:search]).order(sort_order).page(params[:page]).per(20)
  end

  def new
    @text_page = TextPage.new
    add_breadcrumb 'New', new_admin_text_page_path
  end

  def edit
    add_breadcrumb 'Edit', edit_admin_text_page_path(@text_page)
  end

  def destroy
    @text_page.destroy
    redirect_to admin_text_pages_path
  end

  def update
    if @text_page.update(text_page_params)
      redirect_to admin_text_pages_path
    else
      render :edit
    end
  end

  def create
    @text_page = TextPage.new(text_page_params)
    if @text_page.save
      redirect_to admin_text_pages_path
    else
      render :edit
    end
  end

  protected

    def sort_column
      TextPage.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def set_text_page
      @text_page = TextPage.find(params[:id])
    end

    def text_page_params
      params.require(:text_page).permit(:content, :url)
    end

    def add_ctl_breadcrumb
      add_breadcrumb 'Text pages', admin_text_pages_path
    end
end
