require 'rails_helper'

describe "Product collection query" do
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

  context "basic product collection query" do
    let!(:products){ FactoryBot.create_list(:product, 5, title: "We're a collection!")}
    let(:query){ "
        query getBasicCollection{
          products{
            title
          }
        }
    "}
    it "returns all products" do
      product_results = result["data"]["products"]
      # we expect database_cleaner to give us a pristine collection
      # on each test.
      expect(product_results.count).to eq 5
      expect(product_results.map{|r| r["title"]}.uniq).to eq(["We're a collection!"])
    end
  end

  context "product collection with limit" do
    let!(:products){ FactoryBot.create_list(:product, 5, title: "We're a collection!")}
    let(:query){
      "
        query getLimitCollection($limit: Int!){
          products(limit: $limit){
            id
          }
        }
      "
    }
    let(:variables){ {"limit"=>3} }
    it "returns a subset of the products" do
      product_results = result["data"]["products"]
      expect(product_results.count).to eq 3
    end
  end

  context "products by category" do
    let!(:right_products){ FactoryBot.create_list(:product, 3, category_ids: [666])}
    let!(:wrong_products){ FactoryBot.create_list(:product, 3, category_ids: [777])}
    let(:query){
      "
        query getCategoryProducts($categoryId: Int!){
          products(category_id: $categoryId){
            id    
          }
        }
      "
    }
    let(:variables){ {"categoryId"=>666} }
    it "returns products only for the given category" do
      right_ids = right_products.map(&:id).map(&:to_s)
      wrong_ids = wrong_products.map(&:id).map(&:to_s)
      category_products = result["data"]["products"]
      product_ids = category_products.map{|p| p["id"]}

      expect(category_products.count).to eq 3
      expect(product_ids).to match_array(right_ids)
      expect(product_ids).not_to match_array(wrong_ids)
    end
  end
  
  context "product sorting" do
    let(:query){
      "
          query getSortedProducts($sortBy: String, $sortDir: String){
            products(sort_by: $sortBy, sort_dir: $sortDir){
              id
            }
          }
       "
      }
    context "wrong parameters sent" do
      let(:variables){ {"sortBy"=>"id"} }
      it "returns an error when invalid values for sort are sent" do
        errors = result["errors"]
        error_messages = errors.map{|e| e["message"]}
        expect(error_messages).to include "sort_by must be one of in_stock,price,rating"
      end
    end

    context "right parameters sent" do
      let!(:best_product){ FactoryBot.create(:product, rating: 5) }
      let!(:meh_product){ FactoryBot.create(:product, rating: 3) }
      let!(:worst_product){ FactoryBot.create(:product, rating: 1) }

      let(:variables){ {"sortBy"=>"rating", "sortDir"=>"asc"} }
      it "returns products sorted by rating asc when asked" do
        sorted_products = result["data"]["products"]
        expect(sorted_products.first["id"]).to eq worst_product.id.to_s
        expect(sorted_products.second["id"]).to eq meh_product.id.to_s
        expect(sorted_products.last["id"]).to eq best_product.id.to_s
      end
    end
  end
end
