require 'rails_helper'

RSpec.feature "Castings", type: :feature do

   Capybara.register_driver :selenium do |app|
     require 'selenium/webdriver'
     profile = Selenium::WebDriver::Firefox::Profile.new
     profile['media.navigator.permission.disabled'] = true
     profile['dom.disable_beforeunload'] = true
     Capybara::Selenium::Driver.new(app, :profile => profile)
   end
   Capybara.current_driver = :selenium

#   scenario "start casting", js: true do
#     visit root_path
#     expect(current_path).to eq root_path
#
#     expect{
#       fill_in 'user[name]', with: 'user01'
#       find('#female').click
#       click_button 'CAST NOW'
#     }.to change(User, :count).by(1).and change(Room, :count).by(1)
#  
#     expect(current_path).to eq room_path
#     expect(page).to have_content '4人集まるまで待ってね'
#     sleep 2
#   end
#  
   scenario "start video chat", js: true do

     using_session :user1 do
       visit root_path
       expect(current_path).to eq root_path
  
       expect{
         fill_in 'user[name]', with: 'user01'
         find('#female').click
         click_button 'CAST NOW'
       }.to change(User, :count).by(1).and change(Room, :count).by(1)
  
       sleep 2
       find('#camera-icon').click
       find('#voice-icon').click
     end

     using_session :user2 do
       visit root_path
       expect(current_path).to eq root_path

       expect{
         fill_in 'user[name]', with: 'user02'
         find('#female').click
         click_button 'CAST NOW'
       }.to change(User, :count).by(1).and change(Room, :count).by(0)
     
       sleep 2
       find('#camera-icon').click
       find('#voice-icon').click
     end
     using_session :user3 do
       visit root_path
       expect(current_path).to eq root_path

       expect{
         fill_in 'user[name]', with: 'user03'
         find('#male').click
         click_button 'CAST NOW'
       }.to change(User, :count).by(1).and change(Room, :count).by(0)
     
       sleep 2
       find('#camera-icon').click
       find('#voice-icon').click
     end
     using_session :user4 do
       visit root_path
       expect(current_path).to eq root_path

       expect{
         fill_in 'user[name]', with: 'user04'
         find('#male').click
         click_button 'CAST NOW'
       }.to change(User, :count).by(1).and change(Room, :count).by(0)
     
       sleep 2
       find('#camera-icon').click
       find('#voice-icon').click

       user = User.find_by(name: 'user04')
       expect(user.room.status).to be_truthy
    
       expect(current_path).to eq room_path
       expect(page).to_not have_content '4人集まるまで待ってね'
     end

     sleep 15

     using_session :user4 do
       expect(current_path).to eq vote_path
       choose 'candidate_1'
       click_button 'submit'
     end
     using_session :user3 do
       expect(current_path).to eq vote_path
       choose 'candidate_1'
       click_button 'submit'
     end
     using_session :user2 do
       expect(current_path).to eq vote_path
       choose 'candidate_4'
       click_button 'submit'
     end
     using_session :user1 do
       expect(current_path).to eq vote_path
       choose 'candidate_4'
       click_button 'submit'
     end

     using_session :user1 do
       fill_in "line", :with "hello!"
       click_on "send"
     end 

   end

end
