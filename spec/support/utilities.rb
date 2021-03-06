include ApplicationHelper

def sign_in(user)
  visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button I18n.t(:sign_in)
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

def sign_out
  click_link I18n.t(:sign_out)
end