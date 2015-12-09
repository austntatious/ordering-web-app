class Product < ActiveRecord::Base
  belongs_to :category
  has_many :product_options
  belongs_to :restaurant
  validates :name, :price, :presence => true

  scope :search, -> (q) {
    q.blank? ?
      where('1 = 1') :
      joins(:category => :restaurant).
        where(
          'products.name iLIKE ? OR products.description iLIKE ? OR categories.name iLIKE ? OR restaurants.name LIKE ?',
          "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%"
        )
  }

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

  def as_json(options)
    {
      id: self.id,
      name: self.name,
      price: self.price,
      description: self.description,
      toppings_limit: self.toppings_limit,
      category_id: self.category_id,
      options: self.product_options
    }
  end
end
