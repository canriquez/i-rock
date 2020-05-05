module ApplicationHelper
  def privacy_options
    rt = Achievement.privacies.map { |k, _v| [k.split('_').first.capitalize, k] }
    # puts "look here"
    # p rt
    rt
  end
end
