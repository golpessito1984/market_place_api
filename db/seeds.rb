# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

seller = FactoryBot.create(:user, email: 'david.ruizdelarosa@gmail.com',
                                  password: '222333')

buyer = FactoryBot.create(:user, email: 'raul.ruizdelarosa@gmail.com',
                                 password: '222333')


(1..50).each do |number|
  FactoryBot.create(:product,
                    user_id: seller.id)
end

order = Order.new(user_id: buyer.id)
order.placements << Placement.new(product_id: Product.first.id, quantity: 3)
order.placements << Placement.new(product_id: Product.second.id, quantity: 1)
order.placements << Placement.new(product_id: Product.third.id, quantity: 2)
order.save

