UserType = GraphQL::ObjectType.define do
  name 'User'
  description 'Somebody to lean on'

  field :id, !types.ID
  field :name, !types.String
  field :followers, -> { types[UserType] }, 'Some followers to lean on'
  field :cities, -> { types[CityType] }, 'Cities visited'
  field :comments, -> { types[CommentType] }, 'comments made by user'
  field :imageUrl, !types.String, 'user image url' do
    resolve -> (user, args, ctx) {
      user.image.url
    }
  end
end

CityType = GraphQL::ObjectType.define do
  name 'City'
  description 'A place to visit'

  field :id, !types.ID
  field :name, !types.String
  field :visitors, !types.Int
  field :favourites, !types.Int
  field :users, -> { types[UserType] }, 'users who visited'
  field :comments, -> { types[CommentType] }, 'comments on city'
end

CommentType = GraphQL::ObjectType.define do
  name 'Comment'
  description 'a message'

  field :id, !types.ID
  field :message, !types.String
end

QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'The root of all queries'

  field :allUsers do
    type types[UserType]
    description 'Everyone in the Universe'
    resolve -> (obj, args, ctx) { User.all }
  end

  field :user do
    type UserType
    description 'The user associated with a given ID'
    argument :id, !types.ID
    resolve -> (obj, args, ctx) { User.find(args[:id]) }
  end

  field :allCities do
    type types[CityType]
    description 'All travel destinations'
    resolve -> (obj, args, ctx) { City.all }
  end

  field :city do
    type CityType
    description 'The city associated with a given ID'
    argument :id, !types.ID
    resolve -> (obj, args, ctx) { City.find(args[:id]) }
  end

end

# Define the mutation type
MutationType = GraphQL::ObjectType.define do
  name 'Mutation'
  description 'The root of all mutations'

  field :addUser, field: AddUserMutation.field
  field :addComment, field: AddCommentMutation.field

end

AddUserMutation = GraphQL::Relay::Mutation.define do
  # Used to name derived types:
  name 'AddUser'

  # Accessible from `input` in the resolve function:
  input_field :userId, !types.ID
  input_field :name, !types.String

  # The result has access to these fields,
  # resolve must return a hash with these keys
  return_field :user, UserType

  # The resolve proc is where you alter the system state.
  resolve -> (inputs, ctx) {
    user = User.create(id: inputs[:userId], name: inputs[:name])
    {user: user}
  }
end

AddCommentMutation = GraphQL::Relay::Mutation.define do
  # Used to name derived types:
  name 'AddComment'

  # Accessible from `input` in the resolve function:
  input_field :userId, !types.ID
  input_field :cityId, !types.ID
  input_field :message, !types.String

  # The result has access to these fields,
  # resolve must return a hash with these keys
  return_field :user, UserType

  # The resolve proc is where you alter the system state.
  resolve -> (inputs, ctx) {
    user = User.find(inputs[:userId])
    user.comments.create!(user_id: inputs[:userId], city_id: inputs[:cityId], message: inputs[:message])

    {user: user}
  }
end


Graph::Schema = GraphQL::Schema.new(
    query: QueryType,
    mutation: MutationType
)
