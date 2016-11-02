# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create(id: '1', name: 'Jon Snow')
user1 = User.create(id: '2', name: 'Ned Stark')

City.create(id: '1', name: 'Winterfell', visitors: 10, favourites: 20)
Comment.create(id: '1', city_id: 1, user_id: 1, message: 'Winterfell is cold')

user.followers << user1
