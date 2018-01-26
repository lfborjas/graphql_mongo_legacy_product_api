class LegacyProduct < ApplicationRecord
  self.table_name = "catalog_product_entity"
  self.primary_key = "entity_id"

  def find_in_solr(args = {})
    solr_url =  ENV["LEGACY_SOLR_URI"]
    raise "Solr server not configured! Set LEGACY_SOLR_URI!" if solr_url.blank?

    @@solr_conn ||= RSolr.connect url: solr_url
    response = @@solr_conn.get('select', params: {q: "id:#{id}"}.merge(args))
    response["response"].fetch("docs", []).first
  end

  def self.export_to_mongo(args = {})
    id = args[:id]
    limit = args[:limit]

    solr_products = if id
                 [LegacyProduct.find(id).find_in_solr]
               elsif limit
                 LegacyProduct.all.order("created_at desc").limit(limit).
                   map(&:find_in_solr).compact
                end
    solr_products.map{|p| Product.from_legacy_solr(p)}
  end
end
