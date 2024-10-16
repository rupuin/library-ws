# frozen_string_literal: true

module Library
  class Service # rubocop:disable Style/Documentation
    def initialize(user_repository:, book_repository:)
      @user_repository = user_repository
      @book_repository = book_repository
    end

    def borrow_book(book_id:, user_id:)
      user = @user_repository.find_by_id(user_id)
      raise StandardError, "User #{user.username} has already borrowed a book." unless user.borrowed_book.nil?

      book = @book_repository.find_by_id(book_id)
      raise StandardError, "Book with id #{book_id} does not exist." unless book
      raise StandardError, "'#{book.title}' is already borrowed by someone else." unless book.borrowed_by.nil?

      @user_repository.add_borrowed_book(user_id, book_id)
      @book_repository.add_borrowed_by(book_id, user_id)

      "Book '#{book}' was succesfully borrowed!"
    end

    def return_book(book_id:, user_id:)
      # TODO: book_id irrelevant as currently it's only one book per user
      user = @user_repository.find_by_id(user_id)
      raise StandardError, "User #{user.username} has not borrowed a book yet." if user.borrowed_book.nil?

      book = @book_repository.find_by_id(book_id)
      raise StandardError, "'#{book.title}' is not lent to anyone." if book.borrowed_by.nil?

      @user_repository.remove_borrowed_book(user_id)
      @book_repository.removed_borrowed_by(book_id)

      "Book '#{book}' was successfully returned!"
    end
  end
end
