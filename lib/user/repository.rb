# frozen_string_literal: true

module User
  class Repository # rubocop:disable Style/Documentation
    def initialize(db)
      @db = db
    end

    def save(user)
      @db.execute('INSERT INTO user (username, password) VALUES (?, ?)', [user.username, user.password])
    end

    def exists?(username)
      result = @db.get_first_row('SELECT username FROM user WHERE username = ?', [username])
      result ? true : false
    end

    def find_by_username(username)
      user = @db.get_first_row('SELECT id, username, password, borrowed_book FROM user WHERE username = ?',
                               [username])
      User.new(
        id: user['id'],
        username: user['username'],
        password: user['password'],
        borrowed_book: user['borrowed_book']
      )
    end

    def find_by_id(user_id)
      user = @db.get_first_row('SELECT id, username, password, borrowed_book FROM user WHERE id = ?', user_id)
      return unless user

      User.new(
        id: user['id'],
        username: user['username'],
        password: user['password'],
        borrowed_book: user['borrowed_book']
      )
    end

    def add_borrowed_book(user_id, book_id)
      @db.execute('UPDATE user SET borrowed_book = ? WHERE id = ?', [book_id, user_id])
    end

    def remove_borrowed_book(user_id)
      @db.execute('UPDATE user SET borrowed_book = null WHERE id = ?', [user_id])
    end
  end
end
