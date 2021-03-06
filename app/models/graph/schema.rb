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
  field :visitors, types.Int
  field :favourites, types.Int
  field :users, -> { types[UserType] }, 'users who visited'
  field :comments, -> { types[CommentType] }, 'comments on city'
  field :imageColor, types.String, 'image overlay color' do
    resolve -> (city, args, ctx) {
      city.color
    }
  end
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
  field :deleteUser, field: DeleteUserMutation.field
  field :addComment, field: AddCommentMutation.field
  field :updateComment, field: EditCommentMutation.field
  field :addCity, field: AddCityMutation.field
  field :addVisitedCity, field: AddCityToUserMutation.field
  field :updateCity, field: UpdateCityMutation.field

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

DeleteUserMutation = GraphQL::Relay::Mutation.define do
  # Used to name derived types:
  name 'DeleteUser'

  # Accessible from `input` in the resolve function:
  input_field :userId, !types.ID

  # The result has access to these fields,
  # resolve must return a hash with these keys
  return_field :user, UserType

  # The resolve proc is where you alter the system state.
  resolve -> (inputs, ctx) {
    user = User.find(inputs[:userId])
    user.destroy
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

AddCityMutation = GraphQL::Relay::Mutation.define do
  # Used to name derived types:
  name 'AddCity'

  # Accessible from `input` in the resolve function:
  input_field :cityId, !types.ID
  input_field :name, !types.String
  input_field :visitors, types.Int
  input_field :favourites, types.Int
  input_field :imageUrl, types.String

  # The result has access to these fields,
  # resolve must return a hash with these keys
  return_field :city, CityType

  # The resolve proc is where you alter the system state.
  resolve -> (object, inputs, ctx) {
    city = City.create(id: inputs[:cityId], name: inputs[:name], visitors: inputs[:visitors],
                       favourites: inputs[:favourites])
    {city: city}
  }
end

AddCityToUserMutation = GraphQL::Relay::Mutation.define do
  # Used to name derived types:
  name 'AddCityToUser'

  # Accessible from `input` in the resolve function:
  input_field :cityId, !types.ID
  input_field :userId, !types.ID

  # The result has access to these fields,
  # resolve must return a hash with these keys
  return_field :user, UserType

  # The resolve proc is where you alter the system state.
  resolve -> (inputs, ctx) {
    user = User.find(inputs[:userId])
    city = City.find(inputs[:cityId])
    user.cities << city
    {user: user}
  }
end

UpdateCityMutation = GraphQL::Relay::Mutation.define do
  # Used to name derived types:
  name 'UpdateCity'

  # Accessible from `input` in the resolve function:
  input_field :cityId, !types.ID
  input_field :favourites, types.Int
  input_field :visitors, types.Int
  input_field :imageUrl, types.String

  # The result has access to these fields,
  # resolve must return a hash with these keys
  return_field :city, CityType

  # The resolve proc is where you alter the system state.
  resolve -> (object, inputs, ctx) {
    city = City.find(inputs[:cityId])
    city.update(image_file_name: inputs[:imageUrl])
    {city: city}
  }
end

EditCommentMutation = GraphQL::Relay::Mutation.define do
  # Used to name derived types:
  name 'EditComment'

  # Accessible from `input` in the resolve function:
  input_field :id, !types.ID
  input_field :message, !types.String

  # The result has access to these fields,
  # resolve must return a hash with these keys
  return_field :comment, CommentType

  # The resolve proc is where you alter the system state.
  resolve -> (inputs, ctx) {
    comment = Comment.find(inputs[:id])
    comment.update(message: inputs[:message])
    { comment: comment }
  }
end

Graph::Schema = GraphQL::Schema.define(
    query: QueryType,
    mutation: MutationType
)
