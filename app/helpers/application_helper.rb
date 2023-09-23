module ApplicationHelper

  def show_svg(path)
    File.open("app/assets/images/#{path}", "rb") do |file|
      raw file.read
    end
  end

  def current_email_message
    @current_email_message ||= EmailMessage.find_or_create_by(user: current_user, status: "open")
  end

  def is_known_user?
    current_user.country_name.present? && current_user.role.present?
  end

  def modal_message
    is_known_user? ? 'Pricing and Literature Tool Settings' : 'Welcome to the Pricing and Literature Tool'
  end

  def modal_selection_prompt
    is_known_user? ? 'You may edit these later if necessary.' : 'Please select your settings. You may edit these later if necessary.'
  end
end
