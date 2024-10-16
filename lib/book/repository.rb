# frozen_string_literal: true

module Book
  class Repository # rubocop:disable Style/Documentation
    def initialize(db)
      @db = db
    end

    def all
      books = @db.execute('SELECT id, title, author, year, borrowed_by FROM book WHERE borrowed_by IS NULL')
      books.map do |book|
        Book.new(
          id: book['id'],
          title: book['title'],
          author: book['author'],
          year: book['year'],
          borrowed_by: book['borrowed_by']
        )
      end
    end

    def save_all(all_books)
      all_books.each do |book|
        @db.execute('INSERT OR IGNORE INTO book (id, title, author, year) VALUES (?, ?, ?, ?)',
                    [book.id, book.title, book.author, book.year])
      end
    end

    def available
      books = @db.execute('SELECT id, title, author, year, borrowed_by FROM book WHERE borrowed_by IS NULL')
      books.map do |book|
        Book.new(
          id: book['id'],
          title: book['title'],
          author: book['author'],
          year: book['year'],
          borrowed_by: book['borrowed_by']
        )
      end
    end

    def find_by_id(book_id)
      book = @db.get_first_row('SELECT id, title, author, year, borrowed_by FROM book WHERE id = ?', book_id)
      return unless book

      Book.new(
        id: book['id'],
        title: book['title'],
        author: book['author'],
        year: book['year'],
        borrowed_by: book['borrowed_by']
      )
    end

    def add_borrowed_by(book_id, user_id)
      @db.execute('UPDATE book SET borrowed_by = ? WHERE id = ?', [user_id, book_id])
    end

    def removed_borrowed_by(book_id)
      @db.execute('UPDATE book SET borrowed_by = null WHERE id = ?', [book_id])
    end
  end
end
