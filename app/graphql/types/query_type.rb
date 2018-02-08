Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  field :product, Types::ProductType do
    description "Get information about a single product"
    argument :id, types.String
    resolve ->(obj, args, ctx) {
      Product.find(args[:id])
    }
  end

  field :products, types[Types::ProductType] do
    description "Get a collection of products"
    # none of these are required, the type would be specified as !types.TYPE if they were
    argument :limit, types.Int, default_value: 10
    argument :brand_id, types.Int
    argument :category_id, types.Int
    argument :sort_by, types.String, prepare: ->(sort_by, ctx){
      allowed_fields = %w[in_stock price rating]
      unless sort_by.in?(allowed_fields)
        return GraphQL::ExecutionError.new("sort_by must be one of #{allowed_fields.join(',')}")
      end
      sort_by
    }
    argument :sort_dir, types.String, default_value: "desc", prepare: ->(sort_dir, ctx){
      allowed_dirs = %w[asc desc]
      unless sort_dir.in?(allowed_dirs)
        return GraphQL::ExecutionError.new("sort_dir must be one of #{allowed_dirs.join(',')}")
      end
      sort_dir
    }

    resolve ->(obj, args, ctx){
      products = Product
      if args[:brand_id].present?
        products = products.where(:brand_ids.in => [args[:brand_id]])
      end

      if args[:category_id].present?
        products = products.where(:category_ids.in => [args[:category_id]])
      end

      if args[:sort_by].present?
        products = products.order_by(args[:sort_by] => args[:sort_dir])
      end

      products = products.limit(args[:limit])
    }
  end
end
