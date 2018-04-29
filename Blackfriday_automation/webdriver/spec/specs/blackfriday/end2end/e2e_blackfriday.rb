describe "Blackfriday end 2 end test", :type => :feature, :js => $javascript_flag do
  before :each do
    @ee_page = BlackfridayPage.new
    @ee_page.load
  end

  it "Test All features" do
    validate_header_footer()
    validate_tabs()
    validate_homepage_withoutLogin()
    register_user("avee","arora.avee@gmail.com","password")
    signin("avee","password")
    home_loggedin_validated()
    products_validate()
    single_product_validate()
    validate_add_to_cart()
    validate_checkout()
  end
end
