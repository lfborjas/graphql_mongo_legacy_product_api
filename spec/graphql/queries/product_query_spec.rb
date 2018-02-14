require 'rails_helper'

describe "Single Product Query" do
  let!(:product){ FactoryBot.create(:product, title: "It's me, product!") }
  # from: http://graphql-ruby.org/schema/testing.html
  let(:context){ {} }
  let(:variables){ {} }
  let(:result){
    res = GraphqlMongoProductApiSchema.execute(
      query,
      context: context,
      variables: variables
    )
    if res["errors"]
      pp res
    end
    res
  }

  context "simple product representation" do
    let(:variables){ {
                       "productId" => product.id.to_s
                     } }
    # The query has to be named so we can declare, and later use, variables:
    # http://graphql-ruby.org/queries/executing_queries
    # http://graphql.org/learn/queries/#variables
    let(:query) {
      "
        query getProduct($productId: String!){
          product(id: $productId){
            id
            title
         }
        }
      "
    }


    it "returns the product's requested data" do
      query_product = result["data"]["product"]
      expect(query_product["id"]).to eq product.id.to_s
      expect(query_product["title"]).to eq "It's me, product!"
    end
  end
end
