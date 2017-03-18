require 'rails_helper'
include BCrypt

RSpec.describe UsersController, type: :controller do

  describe 'POST index' do
    it 'creates a user' do
      params = {user: {name: 'Ale', surname: 'sobko', email: 'ale@mail.com', password: 'veryStrong2017'}}
      post :create, params: params
      user = User.first
      json = JSON.parse(response.body)

      expect(json['user']).to eq 'created'
      expect(user.surname).to eq 'sobko'
      expect(user.email).to eq 'ale@mail.com'
    end

    describe 'failing' do
      it 'without a real email' do
        params = {user: {name: 'Ale', surname: 'sobko', email: 'notAnEmail', password: 'veryStrong2017'}}
        post :create, params: params
        json = JSON.parse(response.body)

        expect(json['email']).to eq ['is invalid']
      end

      it 'without a strong password' do
        params = {user: {name: 'Ale', surname: 'sobko', email: 'real_email@mail.com', password: 'not_Strong_password'}}
        post :create, params: params
        json = JSON.parse(response.body)

        expect(json['password']).to eq ['password is not strong']
      end

      it 'with repeated email' do
        params = {user: {name: 'Ale', surname: 'sobko', email: 'ale@mail.com', password: 'Password_123'}}
        post :create, params: params

        params = {user: {name: 'Ale', surname: 'sobko', email: 'ale@mail.com', password: 'Password_123'}}
        post :create, params: params

        json = JSON.parse(response.body)

        expect(json['email']).to eq ['has already been taken']
      end

      it 'with invalid password confirmation' do
        params = {user: {name: 'Ale', surname: 'sobko', email: 'ale@mail.com', password: 'Password_123', password_confirmation: 'otherPassw2'}}
        post :create, params: params

        json = JSON.parse(response.body)

        expect(json['password_confirmation']).to eq ["doesn't match Password"]
      end
    end
  end

end
