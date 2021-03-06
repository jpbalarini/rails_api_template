require 'spec_helper'

RSpec.describe User do
  it 'has a valid factory' do
    old_count = User.count
    expect(FactoryGirl.create(:user)).to be_valid
    FactoryGirl.create_list(:user, 9)
    expect(User.count).to eq old_count + 10
  end

  it 'full_name returns correct name' do
    # Email users
    email_user = FactoryGirl.create(:user)
    full_name = email_user.full_name
    expect(full_name).to eq email_user.username
    # Facebook users
    fb_user = FactoryGirl.create(:user_with_fb)
    full_name_fb = fb_user.full_name
    expect(full_name_fb).to eq fb_user.first_name + ' ' + fb_user.last_name
  end
end
