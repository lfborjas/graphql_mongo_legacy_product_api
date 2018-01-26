class LegacyProduct < ApplicationRecord
  self.table_name = "catalog_product_entity"
  self.primary_key = "entity_id"

  def find_in_solr(args = {})
    solr_url =  ENV["LEGACY_SOLR_URI"]
    raise "Solr server not configured! Set LEGACY_SOLR_URI!" if solr_url.blank?

    @@solr_conn ||= RSolr.connect url: solr_url
    response = @@solr_conn.get('select', params: {q: "id:#{id}"}.merge(args))
  end
end
