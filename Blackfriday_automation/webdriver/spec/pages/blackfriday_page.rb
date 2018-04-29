class Components < SitePrism::Section
  element :video_logo,".ee-components-text"
  elements :videos , ".ee-components-thumbnail-strip-cell"
  elements :video_play,".ee-components-play-button-frame"
end

class VideoSection < SitePrism::Section
  sections :components, Components, ".ee-components-row"
end

class SingleVideo < SitePrism::Section
  elements :play, ".ee-components-center-element"
end


############################################
# Blackfriday Page Object
class BlackfridayPage < SitePrism::Page
  set_url ""
  element :logo,".ax_default.label",:text => "BlackFriday"
  elements :brand, ".ax_default.label",:text => "Brand"
  element :home, ".ax_default.label",:text => "Home"
  element :product, ".ax_default.label",:text => "Products"
  elements :deal, ".ax_default.label",:text => "Deals"
  elements :my_account, ".ax_default.label",:text => "My Account"
  element :cart,".ax_default.label",:text => "Cart"
  element :deals_of_day,".ax_default.label",:text => "Deal's Of The Day"
  element :categories_logo,".ax_default.label",:text => "Categories"
  element :brands_logo,".ax_default.label",:text => "Brand's"
  element :category_arrow,"#u24_img"
  element :brands_arrow,"#u53_img"
  element :login,".ax_default.label",:text => "Login"
  element :register,".ax_default.label",:text => "Register"
  element :logout,".ax_default.label",:text => "Logout"
  element :carousel,"#u0"
  element :apple_image,"#u35"
  element :items_number,"#u691"
  element :add_item,"#u553_img"
  element :item_quantity,"#u557"
  element :delete,"#u624_img"
  element :amount,"#u695"
  element :sony_image,"#u37"
  element :hp_image,"#u39"
  element :samsung_image,"#u41"
  element :philips_image,"#u43"
  element :apple_single_product,"#u3181"
  element :contact,".ax_default.label",:text => "Contact Info"
  elements :email,".ax_default.label",:text => "blackfriday@support.com"
  element :recommendation_logo,".ax_default.label",:text => "Recommendations"
  element :welcome_user,".ax_default.label",:text => "Welcome"
  element :product_electronics,".ax_default.label",:text => "Electronics"
  element :product_cellphonese,".ax_default.label",:text => "CELL PHONES"
  element :brand_samsung,".ax_default.label",:text => "SAMSUNG"
  element :brand_apple,".ax_default.label",:text => "APPLE"
  element :account_orders,".ax_default.label",:text => "YOUR ORDERS"
  element :sign_in_logo,".ax_default.label",:text => "Sign In"
  element :username,".ax_default.label",:text => "Username"
  elements :text_boxes,".ax_default.text_field input"
  element :password,".ax_default.label",:text => "Password"
  elements :buttons,".ax_default.primary_button"
  elements :register_button,".ax_default.button"
  element :email_error_signin,".ax_default.label",:text => "Email Required"
  element :password_error,".ax_default.label",:text => "Password Required"
  element :registration_logo,".ax_default.label",:text => "Registration"
  element :user_name,".ax_default.label",:text => "Your Name"
  element :email_logo,".ax_default.label",:text => "Email"
  element :name_error,".ax_default.label",:text => "Enter Name"
  element :email_error,".ax_default.label",:text => "Enter Email"
  section :video_section,VideoSection,".ee-components-style-global.ee-components-grid"
  element :video_back,".ee-components-style-navigation"
  element :video_play, ".ee-components-play-button-frame"
  element :add_address,".ax_default.box_1",:text => "Add a new address"
  element :add_credit,".ax_default.label",:text => "Add a credit card or debit card"
  element :order_detail,"text",:text => "   Order details"
  element :order_number,".ax_default.label",:text => "Order #34453 - 45353"
  section :single_video,SingleVideo,".ee-template-featured"
  elements :checkout,".ax_default.label",:text => "Checkout"
  elements :place_order,".ax_default.label",:text => "Place your order"


end
