namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Example User",
                         email: "example@railstutorial.org",
                         password: "foobar",
                         password_confirmation: "foobar")
    admin.toggle!(:admin)

    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    users = User.all(limit: 6)
    users.each do |user|
      5.times do |i|
        category_name = "MY CATEGORY #{i}"
        user.categories.create!(name: category_name)
        10.times do |j|
          item_barcode_custom = "cat#{i} item #{j}"
          user.items.create!(barcode_custom: item_barcode_custom)
        end
      end
    end
  end
end