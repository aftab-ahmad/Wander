class GraphqlController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def query
    result_hash = Graph::Schema.execute(params[:query], variables: params[:variables])
    render json: result_hash
  end

  def schema
    query = "query{\n  __schema{\n    queryType{\n      name\n    }\n    mutationType{\n      name\n    }\n
      types{\n      kind\n      name\n      description\n      inputFields{\n        name\n
      description\n      }\n      fields{\n        name\n        description\n        type{\n
      kind\n          name\n          ofType{\n            kind\n            name\n            ofType{\n
      kind\n              name\n            }\n          }\n        }\n      }\n      enumValues {\n
      name\n      }\n      possibleTypes {\n        name\n      }\n    }\n    directives{\n      name\n      description\n
      locations\n      args{\n        name\n        description\n        type{\n          kind\n          name\n
      ofType{\n            kind\n            name\n            ofType{\n              kind\n              name\n
      }\n          }\n        }\n        defaultValue\n      }\n    }\n  }\n}"
    result_hash = Graph::Schema.execute(query, variables: params[:variables])
    render json: result_hash
  end
end
