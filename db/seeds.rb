# coding: utf-8

User.create!(name: "管理者",
            email: "sample@email.com",
            password: "password",
            password_confirmation: "password",
            admin: true)

            #User.create!(name: "上長1",
            #email: "sample-j1@email.com",
            #password: "password",
            #password_confirmation: "password",
            #superior: true)

            #User.create!(name: "test",
            #email: "test@test.com",
            #password: "password",
            #password_confirmation: "password",
            #uperior: false)

BasePoint.create!(base_point_name: "拠点A",
                base_point_type: "出勤",
                base_point_number: "1")

#60.times do |n|
#    name = Faker::Name.name
#    email = "sample-#{n+1}@email.com"
#    password = "password"
#    User.create!(name: name,
#                email: email,
#                password: password,
#                password_confirmation: password)
#end