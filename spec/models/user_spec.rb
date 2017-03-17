require 'rails_helper'
include BCrypt

RSpec.describe User, type: :model do

  describe 'new user' do
    it 'creates a new user' do
      user = User.new({name: 'Ale', surname: 'Sobko', email: 'ale@mail.com', password: 'PassW0rd1'})

      expect(user.save).to eq true
      expect(user.name).to eq 'Ale'
      expect(user.surname).to eq 'Sobko'
      expect(user.email).to eq 'ale@mail.com'
      expect(Password.new(user.password).is_password?('PassW0rd1')).to eq true
    end

    describe 'do not create a new user' do
      it 'requires name' do
        user = User.new({surname: 'Sobko', email: 'sad@mail.com', password: 'Password1'})

        expect(user.save).to eq false
      end

      it 'requires a real email' do
        user = User.new({name: 'ale', surname: 'Sobko', email: 'asd', password: 'Password1'})

        expect(user.save).to eq false
        expect(user.errors.messages[:email]).to eq ['is invalid']
      end

      it 'requires a strong password' do
        user = User.new({name: 'ale', surname: 'Sobko', email: 'asd@mail.com', password: 'abc'})

        expect(user.save).to eq false
        expect(user.errors.messages[:password]).to eq ['password is not strong']
      end
    end

  end

  describe 'existing users' do
    it 'does not create with repeated email' do
      user1 = User.new({name: 'ale', surname: 'Sobko', email: 'ale1@mail.com', password: 'Password1'})
      user2 = User.new({name: 'ale', surname: 'Sobko', email: 'ale1@mail.com', password: 'Password1'})

      expect(user1.save).to eq true
      expect(user2.save).to eq false
    end
  end

  describe 'audited' do
    it 'update' do
      user = FactoryGirl.create(:user)

      expect(user.audits.size).to eq 1
      expect(user.audits.first.action).to eq 'create'
      expect(user.audits.first.version).to eq 1

      user.update_attributes!(name: 'new name')

      expect(user.audits.size).to eq 2
      expect(user.audits.last.action).to eq 'update'
      expect(user.audits.last.version).to eq 2
    end

    it 'destroy' do
      user = FactoryGirl.create(:user)

      expect(user.audits.size).to eq 1
      expect(user.audits.first.action).to eq 'create'
      expect(user.audits.first.version).to eq 1

      user.destroy!

      expect(user.audits.size).to eq 2
      expect(user.audits.last.action).to eq 'destroy'
      expect(user.audits.last.version).to eq 2
      expect(Product.all.size).to eq 0
    end
  end
end
