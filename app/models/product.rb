class Product
  include Mongoid::Document
  field :id, type: String
  field :slug, type: String
  field :is_men, type: Boolean
  field :is_women, type: Boolean
  field :title, type: String
  field :type, type: String
  field :sku, type: String
  field :brand, type: String
  field :brand_id, type: Integer
  field :description, type: String
  field :availability, type: String
  field :in_stock, type: Boolean
  field :price, type: Float
  field :category_ids, type: Array
  field :brand_ids, type: Array
  field :rating, type: Float

  def self.from_legacy_solr(solr_data)
    create(solr_data.slice(*%w[id slug is_men is_women title type sku brand brand_id description availability in_stock price category_ids brand_ids rating]))
  end
end
