FactoryGirl.define do
  factory :leader do
    name { Faker::Name.name }

    # Random 91 character alphanumeric string
    streak_key {
      range = [*'0'..'9',*'A'..'Z',*'a'..'z']
      Array.new(91){ range.sample }.join
    }

    gender { [ "Male", "Female", "Other" ].sample }
    year { [ "2016", "2017", "Graduated", "Unknown" ].sample }
    email { Faker::Internet.email }
    slack_username { [ Faker::Internet.user_name, nil ].sample }
    github_username { [ Faker::Internet.user_name, nil ].sample }
    twitter_username { [ Faker::Internet.user_name, nil ].sample }
    phone_number { [ Faker::PhoneNumber.phone_number, nil ].sample }
    address { [ HCFaker::Address.full_address, nil ].sample }
    latitude { Faker::Address.latitude if address }
    longitude { Faker::Address.longitude if address }

    factory :leader_with_address do
      address { HCFaker::Address.full_address }
      latitude { Faker::Address.latitude }
      longitude { Faker::Address.longitude }
    end
  end
end
