FactoryBot.define do
  factory :achievement do
    sequence(:title) { |n| "Achievement #{n}"}
    #title { "Title" }
    description { "Description" }
    privacy { Achievement.privacies[:private_access] }
    features { false }
    cover_image { "some_file.png" }
  end

end
