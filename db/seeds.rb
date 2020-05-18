# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
user = FactoryBot.create(:user, email: 'david.ruizdelarosa@gmail.com',
                                password: '222333')

(1..50).each do |number|
  FactoryBot.create(:product,
                    user_id: user.id)
end
