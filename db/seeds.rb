# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user1 = User.create(email: 'q@q.ru', password: 123_456)
user2 = User.create(email: 'r@r.ru', password: 123_456)

question1 = Question.create(title: 'Почему?', body: 'Почему?', user: user1)
Question.create(title: 'Почемуже?', body: 'Почему же?', user: user2)

Answer.create(body: 'Почему?', question: question1, user: user1)
Answer.create(body: 'Потому!', question: question1, user: user2)
