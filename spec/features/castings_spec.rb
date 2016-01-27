require 'rails_helper'

RSpec.feature "Castings", type: :feature do

   Capybara.register_driver :selenium do |app|
     require 'selenium/webdriver'
     profile = Selenium::WebDriver::Firefox::Profile.new
     profile['media.navigator.permission.disabled'] = true
     Capybara::Selenium::Driver.new(app, :profile => profile)
   end
   Capybara.current_driver = :selenium

   scenario "start casting", js: true do
     visit root_path
     expect(current_path).to eq root_path
  
     expect{
       fill_in 'user[name]', with: 'user01'
       find('#female').click
       click_button 'CAST NOW'
     }.to change(User, :count).by(1).and change(Room, :count).by(1)
  
     expect(current_path).to eq room_path
     expect(page).to have_content '４人集まるまで待ってね'
  
     # save_and_open_page
   end
  
   scenario "start video chat", js: true do
     room = Room.create
  
     room.users.create(name: 'user01', gender: 'male')
     room.users.create(name: 'user02', gender: 'female')
     room.users.create(name: 'user03', gender: 'female')
  
     visit root_path
     expect(current_path).to eq root_path
  
     expect{
       fill_in 'user[name]', with: 'user04'
       find('#male').click
       click_button 'CAST NOW'
     }.to change(User, :count).by(1).and change(Room, :count).by(0)
  
     binding.pry
  
     user = User.find_by(name: 'user04')
     expect(user.room.status).to be_truthy
  
     expect(current_path).to eq room_path
     expect(page).to_not have_content '４人集まるまで待ってね'
   end

end
