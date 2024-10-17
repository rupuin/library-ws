# frozen_string_literal: true

module Database # rubocop:disable Style/Documentation
  class << self
    def connect(db_file)
      @connect ||= setup(db_file)
    end

    def close
      return unless @connect

      @connect.close
      @connect = nil
    end

    private

    def setup(db_file)
      db = SQLite3::Database.new(db_file)
      db.results_as_hash = true
      enable_foreign_keys(db)
      create_user_table(db)
      create_book_table(db)
      create_user_index_on_username(db)
      create_book_index_on_title(db)
      db
    end

    def enable_foreign_keys(db)
      db.execute('PRAGMA foreign_keys = ON')
    end

    def create_user_table(db)
      db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS user (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(100),
    password VARCHAR(60),
    borrowed_book INTEGER,
    FOREIGN KEY (borrowed_book) REFERENCES book(id)
  );
      SQL
    end

    def create_user_index_on_username(db)
      db.execute <<-SQL
      CREATE INDEX IF NOT EXISTS index_user_on_username
      ON user (username);
      SQL
    end

    def create_book_table(db)
      db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS book (
    id INTEGER PRIMARY KEY,
    title VARCHAR(100),
    author VARCHAR(100),
    year INTEGER,
    borrowed_by INTEGER,
    FOREIGN KEY (borrowed_by) REFERENCES user(id)
    );
      SQL
    end

    def create_book_index_on_title(db)
      db.execute <<-SQL
        CREATE INDEX IF NOT EXISTS index_book_on_title
        ON book (title);
      SQL
    end
  end
end
