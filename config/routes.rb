Rails.application.routes.draw do
  resources :people, :only => [:index, :show]
  post '/graphql', to: 'graphql#query'
  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
end
