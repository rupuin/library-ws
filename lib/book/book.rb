# frozen_string_literal: true

module Book
  class Book # rubocop:disable Style/Documentation
    attr_accessor :id, :title, :author, :year, :borrowed_by

    def initialize(id:, title:, author:, year:, borrowed_by: nil)
      @id = id
      @title = title
      @author = author
      @year = year
      @borrowed_by = borrowed_by
    end

    def to_s
      "#{@id} #{@title}, #{@author} #{@year}"
    end
  end
end
