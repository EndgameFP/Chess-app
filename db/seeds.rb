# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.destroy_all

user = User.create(email: 'test@yahoo.com', password: 'password', 
	password_confirmation: 'password')
user.save!

user = User.create(email: 'test@gmail.com', password: 'password', 
	password_confirmation: 'password')
user.save!

user = User.create(email: 'test@hotmail.com', password: 'password', 
	password_confirmation: 'password')
user.save!

user = User.create(email: 'testzz@yahoo.com', password: 'password', 
	password_confirmation: 'password')
user.save!

