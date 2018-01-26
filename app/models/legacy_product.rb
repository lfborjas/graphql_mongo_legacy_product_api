class LegacyProduct < ApplicationRecord
  self.table_name = "catalog_product_entity"
  self.primary_key = "entity_id"
end
