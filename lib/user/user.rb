# frozen_string_literal: true

module User
  class User # rubocop:disable Style/Documentation
    attr_accessor :id, :username, :password, :borrowed_book

    def initialize(username:, password:, borrowed_book: nil, id: nil)
      @id = id
      @username = username
      @password = password
      @borrowed_book = borrowed_book
    end

    def to_s
      "#{@id} #{@username} #{@borrowed_book}"
    end
  end
end
