# frozen_string_literal: true

require_relative '../lib/loader'
require 'sqlite3'

db = Database.connect('library.db')

user_repo = User::Repository.new(db)
book_repo = Book::Repository.new(db)

books_from_csv = Book::Parser.from_csv('books.csv')
book_repo.save_all(books_from_csv)

library = Library::Service.new(user_repository: user_repo, book_repository: book_repo)

authenticated = false
current_user = nil

loop do
  puts "Welcome to the Library\n"

  until authenticated
    print 'Enter your username: '
    username = gets.chomp

    if !user_repo.exists?(username)
      puts "User '#{username}' not found. Do you want to register?"
      puts "1. Yes\n2. No"

      print 'Choice: '
      register_choice = gets.chomp.to_i

      case register_choice
      when 1
        puts
        print "Enter new password for '#{username}': "
        new_password1 = gets.chomp
        print 'Repeat the password: '
        new_password2 = gets.chomp
        puts
        if new_password1 == new_password2
          new_user = User::User.new(username: username, password: new_password2)
          user_repo.save(new_user)
          puts "User '#{new_user.username}' was successfully created!\n"
          current_user = user_repo.find_by_username(username)
          authenticated = true
        end
      when 2
        next
      end
    else
      current_user = user_repo.find_by_username(username)
      print "Enter password for '#{current_user.username}': "
      entered_password = gets.chomp
      if current_user.password == entered_password
        authenticated = true
      else
        puts 'Incorrect password. Try again.'
        puts
      end
    end
  end

  puts "Hi #{current_user.username}, what do you want to do?"
  puts
  puts '1. List available books.'
  puts '2. Borrow a book.'
  puts '3. Return a book.'
  puts '4. Exit'
  puts
  print 'Choice: '
  user_choice = gets.chomp.to_i
  puts

  case user_choice
  when 1
    puts '---- 1. Available books ----'
    puts
    puts book_repo.available
    puts
  when 2
    puts '---- 2. Borrow a book ----'
    puts
    print 'Enter a book id: '
    book_id = gets.chomp
    begin
      puts library.borrow_book(book_id: book_id, user_id: current_user.id)
    rescue StandardError => e
      puts "Borrowing failed: #{e.message}"
    end
  when 3
    begin
      puts "CURR USER #{current_user}"
      puts library.return_book(book_id: current_user.borrowed_book, user_id: current_user.id)
    rescue StandardError => e
      puts "Return failed: #{e.message}"
    end
  when 4
    puts 'Ciao!'
    break
  end
end

db.close
