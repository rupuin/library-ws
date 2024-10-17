# frozen_string_literal: true

require 'bcrypt'

module Authenticator
  class Service # rubocop:disable Style/Documentation
    def initialize(user_repository:)
      @user_repo = user_repository
    end

    def user_exists?(username:)
      user_exists = @user_repo.exists?(username)
      user_exists ? true : false
    end

    def passwords_match?(password1:, password2:)
      password1 == password2
    end

    def login(username:, password:)
      user = @user_repo.find_by_username(username)
      return unless user && validate_password(stored_pw: user.password, entered_pw: password)

      user
    end

    def signup(username:, password:)
      user_exists = @user_repo.exists?(username)
      return if user_exists

      hashed_pw = BCrypt::Password.create(password)
      @user_repo.save(User::User.new(username: username, password: hashed_pw))
      @user_repo.find_by_username(username)
    end

    private

    def validate_password(stored_pw:, entered_pw:)
      BCrypt::Password.new(stored_pw) == entered_pw
    end
  end
end
