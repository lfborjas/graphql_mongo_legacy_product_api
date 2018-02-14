FactoryBot.define do
  factory :product do
    slug 'test-product'
    is_men false
    is_women true
    title "Test Product"
    type 'simple'
    sku 'TESTP'
    brand 'HomeFill'
    description "This is a test product"
    availability 'available'
    in_stock true
    price 6.66
    rating 4
  end
end
