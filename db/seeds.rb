# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# 5.times{|i| User.create(name:"#{i}")}
# 5.times{|i| Interview.create(name:"Interview - #{i}", user_id:i)}
5.times{|i| Interviewer.create(interview_id:i, user_id:i)}

