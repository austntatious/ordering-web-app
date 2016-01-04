# product option class
class ProductOption < ActiveRecord::Base
  belongs_to :product
  has_and_belongs_to_many :product_options, :join_table => :product_options_line_items

  def as_json
  	{
  		id: self.id,
  		name: self.name,
  		price: self.price
  	}
  end
end
