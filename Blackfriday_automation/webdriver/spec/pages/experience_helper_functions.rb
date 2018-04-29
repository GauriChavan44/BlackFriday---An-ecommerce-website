
#######################################################################################
##########all functions#########################################
def validate_header_footer()
  begin
    puts "Validate the logo"
    expect(@ee_page.logo.text).to eq("BlackFriday")
    puts "Validate the menu options "
    puts "Validate the brand button"
    puts "Validate the Product button"
    expect(@ee_page.product.text).to eq("Products")
    puts "Validate the Deals button"
    expect(@ee_page.brand[1].text).to eq("Brand")
    puts "Validate the home button"
    expect(@ee_page.home.text).to eq("Home")
    puts "Validate the Deals button"
    expect(@ee_page.deal[1].text).to eq("Deals")
    puts "Validate the my account button"
    expect(@ee_page.my_account[0].text).to eq("My Account")
    puts "Validate the cart button"
    expect(@ee_page.cart.text).to eq("Cart")
    puts "Validate the login button"
    expect(@ee_page.login.text).to eq("Login")
    puts "Validate the register button"
    expect(@ee_page.register.text).to eq("Register")
    puts "Validate the footer options"
    puts "Validate the contact information"
    expect(@ee_page.contact.text).to eq("Contact Info")
    puts "Validate the email information"
    expect(@ee_page.email[1].text).to eq("blackfriday@support.com")

  end
end

def validate_tabs()
  begin
    puts "clicking on Product"
    @ee_page.product.click
    puts "Validate the product options"
    expect(@ee_page.product_cellphonese.text).to eq("CELL PHONES")
    expect(@ee_page.product_electronics.text).to eq("Electronics")
    @ee_page.product.click
    puts "Click on the Brands"
    @ee_page.brand[1].click
    expect(@ee_page.brand_samsung.text).to eq("SAMSUNG")
    expect(@ee_page.brand_apple.text).to eq("APPLE")
    @ee_page.brand[1].click
    puts "Click on My Account"
    @ee_page.my_account[0].click
    puts "Validate the my account tab"
    expect(@ee_page.account_orders.text).to eq("YOUR ORDERS")
    @ee_page.my_account[0].click
  end
end

def validate_homepage_withoutLogin()
  begin
    puts "Validate the Login button"
    expect(@ee_page.login.text).to eq("Login")
    puts "Validate the register button"
    expect(@ee_page.register.text).to eq("Register")
    puts "Validate the Carousel of deals"
    expect(@ee_page.has_carousel?).to eq(true)
    puts "Click on the categories slider "
    @ee_page.category_arrow.click
    sleep(1)
    @ee_page.category_arrow.click
    puts "Validate the availabe brands"
    puts "Validate the Apple logo"
    expect(@ee_page.has_apple_image?).to eq(true)
    puts "Validate the Sony logo"
    expect(@ee_page.has_sony_image?).to eq(true)
    expect(@ee_page.has_apple_image?).to eq(true)
    puts "Validate the Samsung logo"
    expect(@ee_page.has_samsung_image?).to eq(true)
    puts "Click on the brands slider "
    @ee_page.brands_arrow.click
    puts "Validate the Samsung logo"
    expect(@ee_page.has_philips_image?).to eq(true)
    sleep(1)
    @ee_page.brands_arrow.click
  end
end

def validate_homepage_withoutLogin()
  begin
    puts "Validate the Login button"
    expect(@ee_page.login.text).to eq("Login")
    puts "Validate the register button"
    expect(@ee_page.register.text).to eq("Register")
    puts "Validate the Carousel of deals"
    expect(@ee_page.has_carousel?).to eq(true)
    puts "Click on the categories slider "
    @ee_page.category_arrow.click
    sleep(1)
    @ee_page.category_arrow.click
    puts "Validate the availabe brands"
    puts "Validate the Apple logo"
    expect(@ee_page.has_apple_image?).to eq(true)
    puts "Validate the Sony logo"
    expect(@ee_page.has_sony_image?).to eq(true)
    expect(@ee_page.has_apple_image?).to eq(true)
    puts "Validate the Samsung logo"
    expect(@ee_page.has_samsung_image?).to eq(true)
    puts "Click on the brands slider "
    @ee_page.brands_arrow.click
    puts "Validate the Samsung logo"
    expect(@ee_page.has_philips_image?).to eq(true)
    sleep(1)
    @ee_page.brands_arrow.click
  end
end


def register_user(name,email,password)
  begin
    puts "Click on register Button"
    @ee_page.register.click
    puts "Validate the register page"
    expect(@ee_page.registration_logo.text).to eq("Registration")
    puts "Validate for error if no data entered in text boxes"
    @ee_page.register_button[0].click
    puts "Validate the error messages"
    expect(@ee_page.name_error.text).to eq("Enter Name")
    expect(@ee_page.email_error.text).to eq("Enter Email")
    puts "enter the values"
    @ee_page.text_boxes[0].set(name)
    @ee_page.text_boxes[1].set(email)
    @ee_page.text_boxes[2].set(password)
    @ee_page.text_boxes[3].set(password)
    puts "click on create account"
    @ee_page.register_button[0].click
  end
end

def signin(name,password)
  begin
    puts "Click on signin Button"
    @ee_page.login.click
    puts "Validate the sign in page"
    expect(@ee_page.sign_in_logo.text).to eq("Sign In")
    puts "Validate for error if no data entered in text boxes"
    @ee_page.buttons[0].click
    puts "Validate the error messages"
    expect(@ee_page.email_error_signin.text).to eq("Email Required")
    expect(@ee_page.password_error.text).to eq("Password Required")
    puts "enter the values"
    @ee_page.text_boxes[0].set(name)
    @ee_page.text_boxes[1].set(password)
    puts "click on sign in "
    @ee_page.buttons[0].click
  end
end


def home_loggedin_validated()
  begin
    puts "validate the logged in your  "
    expect(@ee_page.has_welcome_user?).to eq(true)
    puts "validate the recommendation options"
    expect(@ee_page.recommendation_logo.text).to eq("Recommendations")
  end
end


def products_validate()
  begin
    puts "Click on Apple brand"
    @ee_page.brand[1].click
    @ee_page.brand_apple.click
    puts "Validate that 5 buttons are available"
    expect(@ee_page.buttons.size).to eq(5)
    puts " Validate the videos "
    puts "enter the iframe"
    page.driver.browser.switch_to.frame(0)
    sleep(1)
    puts "Validate the heading of videos"
    expect(@ee_page.video_section.components[0].video_logo.text).to eq("Featured Iphone Videos")
    puts "click on 1st video"
    @ee_page.video_section.components[1].videos[0].click
    sleep(5)
    page.driver.browser.switch_to.default_content
    sleep(1)
    page.driver.browser.switch_to.frame(1)
    sleep(1)
    @ee_page.video_back.click
    page.driver.browser.switch_to.default_content
    sleep(1)
  end
end

def single_product_validate()
  begin
    puts "Click on shop now"
    @ee_page.buttons[0].click
    puts "Validate the apple details"
    expect(@ee_page.has_apple_single_product?).to eq(true)
    puts "Validate the video"
    page.driver.browser.switch_to.frame(0)
    sleep(1)
    @ee_page.single_video.play[0].click
    sleep(2)
    page.driver.browser.switch_to.default_content
    sleep(1)
    puts "add to cart"
    @ee_page.buttons[1].click
  end
end

def validate_add_to_cart()
  begin
    puts "Vaildate Item quantity"
    expect(@ee_page.items_number.text).to eq("3")
    puts "Validate Amount"
    expect(@ee_page.amount.text).to eq("761")
    puts "increase the quantity"
    @ee_page.add_item.click
    sleep(1)
    puts "validate the new quantity"
    expect(@ee_page.items_number.text).to eq("4")
    puts "delete the item "
    @ee_page.delete.click
    sleep(1)
    puts "Validate new Amount"
    expect(@ee_page.amount.text).to eq("800")
    puts "Click on checkout"
    @ee_page.register_button[1].click
  end
end

def validate_checkout()
  begin
    puts "Vaildate checkout Label"
    expect(@ee_page.checkout[1].text).to eq("Checkout")
    puts "click on add new address"
    @ee_page.add_address.click
    puts "add the details"
    @ee_page.text_boxes[0].set("avee arora")
    @ee_page.text_boxes[1].set("24 c")
    @ee_page.text_boxes[2].set("saint alphonsus street")
    @ee_page.text_boxes[3].set("boston")
    @ee_page.text_boxes[4].set("MA")
    @ee_page.text_boxes[5].set("02120")
    @ee_page.text_boxes[6].set("8572509136")
    puts "click on cancel"
    @ee_page.buttons[1].click
    puts "use this address"
    @ee_page.buttons[0].click
    puts "add credit card"
    @ee_page.add_credit.click
    sleep(1)
    @ee_page.buttons[1].click
    sleep(1)
    puts "Use a payemnt card"
    @ee_page.buttons[0].click
    puts "Click on place order"
    @ee_page.buttons[0].click
    puts "continue shooping"
    sleep(1)
    @ee_page.register_button[0].click
    puts "Test Passed"
  end
end
