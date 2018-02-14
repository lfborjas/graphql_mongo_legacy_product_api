require 'rails_helper'

describe "Single Product Query" do
  # from: http://graphql-ruby.org/schema/testing.html
  let(:context){ {} }
  let(:variables){ {} }
  let(:result){
    res = GraphqlMongoProductApiSchema.execute(
      query,
      context: context
      variables: variables
    )
    if res["errors"]
      pp res
    end
    res
  }

  context "simple product representation" do
    let(:query) {
      <<-GRAPHQL
        query{
          product(id: $productId){
            id
            title
         }
        }
      GRAPHQL
    }
    let(:variables){ }
    
  end
end
