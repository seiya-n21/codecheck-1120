# coding: utf-8

require 'rails_helper'

RSpec.feature 'Castings', type: :feature do
  scenario '入退室ができること', js: true do
    visit root_path
    expect(current_path).to eq root_path
    expect{
      fill_in 'user[name]', with: 'user01'
      find('#male').click
      click_button 'CAST NOW'
    }.to change(User, :count).by(1).and change(Room, :count).by(1)

    # window_idを取得するために若干時間が必要
    sleep 5

    expect(current_path).to eq room_path
    expect(User.find(1).window_id).to_not be_nil
    expect(Room.find(1).male).to eq 1

    find('#exit_button').click
    expect(current_path).to eq root_path
    expect(Room.find(1).male).to eq 0
  end

  scenario '4人でビデオチャットできること', js: true do
    users = [
      { symbol: :user1, name: 'user01', gender: 'female', vote: 'candidate_4' },
      { symbol: :user2, name: 'user02', gender: 'female', vote: 'candidate_4' },
      { symbol: :user3, name: 'user03', gender: 'male', vote: 'candidate_1' },
      { symbol: :user4, name: 'user04', gender: 'male', vote: 'candidate_1' }
    ]

    users.each_with_index do |user, index|
      using_session user[:symbol] do
        visit root_path
        expect(current_path).to eq root_path

        n = index == 0 ? 1 : 0
        expect{
          fill_in 'user[name]', with: user[:name]
          find("##{user[:gender]}").click
          click_button 'CAST NOW'
        }.to change(User, :count).by(1).and change(Room, :count).by(n)

        find('#camera-icon').click
        find('#voice-icon').click

        expect(current_path).to eq room_path
        room_status = Room.find(1).status

        case index
        when 0, 1, 2
          expect(room_status).to eq 1
          expect(page).to have_content '4人集まるまで待ってね'
        when 3
          expect(room_status).to eq 2
          expect(page).to_not have_content '4人集まるまで待ってね'
          expect(page).to have_content '終了まで'
        end

        sleep 5
        expect(User.find_by(name: user[:name]).window_id).to_not be_nil
      end
    end

    sleep 10

    users.each do |user|
      using_session user[:symbol] do
        expect(current_path).to eq vote_path
        choose user[:vote]
        click_button 'submit'
      end
    end

    sleep 7

    using_session :user4 do
      fill_in 'line', with: 'hello!'
      click_on 'send'
    end

    using_session :user4 do
      fill_in 'line', with: 'hello!'
      click_on 'send'
    end
  end
end
