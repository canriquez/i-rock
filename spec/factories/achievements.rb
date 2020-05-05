FactoryBot.define do
  factory :achievement do
    sequence(:title) { |n| "Achievement #{n}" }
    # title { "Title" }
    description { 'Description' }
    #privacy { Achievement.privacies[:private_access] }

    features { false }
    cover_image { 'some_file.png' }

    #after the common parameters, we create the special sub methods 
    #for private and public achievements

    factory :public_achievement do
      #privacy { Achievement.privacies[:public_access] }
      privacy { :public_access }
    end

    factory :private_achievement do
      privacy { :private_access }
    end

  end
end
