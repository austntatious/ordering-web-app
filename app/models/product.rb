class Product < ActiveRecord::Base
  belongs_to :category
  has_many :product_options
  validates :name, :price, :presence => true

  scope :by_restaurant, -> (restaurant) { where('category_id IN (SELECT id FROM categories WHERE restaurant_id = ?)', restaurant) }

  has_and_belongs_to_many :products,
    :join_table => :related_products,
    :foreign_key => :product_id,
    :association_foreign_key => :related_product_id

  before_destroy :ensure_not_referenced

  accepts_nested_attributes_for :product_options, :reject_if => :all_blank, :allow_destroy => true

  def ensure_not_referenced
    if LineItem.where(:product_id => self.id).any?
      self.errors.add(:base, 'This product is referenced by cart or order')
      return false
    end
  end

  def get_restaurant
    self.category.try(:restaurant_id)
  end
end
