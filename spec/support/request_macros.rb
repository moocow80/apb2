module RequestMacros
  def request_login(user)
    visit login_path
    fill_in "Email", :with => user.email
    fill_in "Password", :with => user.password
    click_button "Log In"
  end
end
