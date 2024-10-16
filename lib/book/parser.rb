# frozen_string_literal: true

require 'csv'

module Book
  module Parser # rubocop:disable Style/Documentation
    class << self
      def from_csv(path)
        books = []

        CSV.foreach(path, headers: true) do |row|
          book = Book.new(id: row['Book ID'], title: row['Book Name'], author: row['Author'], year: row['Release Year'])
          books << book
        end
        books
      end
    end
  end
end
