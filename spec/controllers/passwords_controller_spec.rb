require 'spec_helper'

describe Api::V1::PasswordsController do
  before :each do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    Delayed::Worker.delay_jobs = false
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @user = FactoryGirl.create(
      :user,
      password: 'mypass123',
      reset_password_token: '1dcce3ffa47fedf0c0fe1d3debba6686982f7e11ff46c43fbcdabd5d7eabadaa',
      reset_password_sent_at: Time.now
    )
  end

  context 'with valid params' do
    it 'should success and send an email' do
      post :create,
        user: {
          email: @user.email
        },
        format: 'json'
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['success']).to eq true
      expect(ActionMailer::Base.deliveries.count).to eq 1
    end

    # reset_password_token is harcoded to match the encryption of the one stored on the db
    it 'should change the password' do
      put :update,
        user: {
          password: '123456789',
          password_confirmation: '123456789',
          reset_password_token: 'oPzALMP1zDFCtBwJ9BXF'
        },
        format: 'json'
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['success']).to eq true
    end
  end

  context 'with invalid params' do
    it 'should success and send an email' do
      post :create,
        user: {
          email: 'notvalid@lala.com'
        },
        format: 'json'
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['success']).to eq false
      ActionMailer::Base.deliveries.count.should == 0
    end

    # reset_password_token is harcoded to match the encryption of the one stored on the db
    it 'should not change the password if confirmation does not match' do
      put :update,
        user: {
          password: '123456789',
          password_confirmation: 'different',
          reset_password_token: 'oPzALMP1zDFCtBwJ9BXF'
        },
        format: 'json'
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['success']).to eq false
    end

    it 'should not change the password if token is invalid' do
      put :update,
        user: {
          password: '123456789',
          password_confirmation: '123456789',
          reset_password_token: 'not valid token'
        },
        format: 'json'
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['success']).to eq false
    end
  end
end
