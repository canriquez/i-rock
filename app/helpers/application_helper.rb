module ApplicationHelper

    def privacyOptions
        rt = Achievement.privacies.map { |k,v| [k.split('_').first.capitalize, k ]}
        puts "look here"
        p rt
        rt
    end

end
