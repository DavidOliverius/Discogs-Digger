require 'discogs'
require 'tty-prompt'
require 'colorize'
require 'colorized_string'
require 'artii'
require 'io/console'

# Disables Deprecated warning from Discogs-wrapper
$VERBOSE = nil

# Disables Hashie error logs from output
Hashie.logger.level = Logger.const_get 'ERROR'

# Class for Menu Choices
class Menu
  attr_accessor :prompt

  def initialize
    @prompt = TTY::Prompt.new
  end

  def format
    prompt.select('What format would you like to dig for?', required: true) do |menu|
      menu.choice 'Vinyl', 'Vinyl'
      menu.choice 'CD', 'CD'
      menu.choice 'All Formats', ''
    end
  end

  def genre
    genre_select = prompt.multi_select('What genre would you like to dig for?', required: true, cycle: true, min: 1,
                                                                                max: 3, per_page: 5) do |menu|
      menu.choice 'House'
      menu.choice 'Techno'
      menu.choice 'Electro'
      menu.choice 'Tech House'
      menu.choice 'Trance'
      menu.choice 'Minimal'
      menu.choice 'Breakbeat'
      menu.choice 'Progressive House'
      menu.choice 'Breaks'
      menu.choice 'Garage House'
      menu.choice 'Psy-Trance'
      menu.choice 'UK Garage'
      menu.choice 'Progressive Trance'
    end

    genre_select.join(', ')
  end

  def year
    prompt.slider('Year', min: 1990, max: 2022, step: 1, default: 1990, required: true)
  end

  def again
    prompt.select('Would you like to dig again?', required: true) do |menu|
      menu.choice 'Yes - same filters' => 1
      menu.choice 'Yes - different filters' => 2
      menu.choice 'No - exit' => 3
    end
  end
end

# Check if '/user' folder exists on start
if Dir.exist?('user')
else
  Dir.mkdir('user')
end

# Check if '/user/user_token.txt' exists
$stdout.clear_screen
begin
  token = File.open('user/user_token.txt')
rescue StandardError
  puts 'Welcome! For first time setup, please generate your personal access token at https://www.discogs.com/settings/developers'
  puts 'Access Token:'
  user_input = gets
  File.write('user/user_token.txt', user_input.strip)
end

# Allows user to print log from Command Line
if ARGV[0] == '-l' || ARGV[0] == '-log' || ARGV[0] == 'log'
  puts File.foreach('user/digger_log.txt') { |line| puts line }
  exit
end

# Allows user to input personal Discogs token from Command Line
if ARGV[0] == '-t' || ARGV[0] == '-token' || ARGV[0] == 'token'
  user_input = ARGV[1]
  File.write('user/user_token.txt', user_input.strip)
  puts "Thank you, your personal access token is now: #{user_input}"
  sleep(2)
  exit
end

token = File.open('user/user_token.txt')
user_token = token.read

@prompt = TTY::Prompt.new
@wrapper = Discogs::Wrapper.new('T1A3')
@auth_wrapper = Discogs::Wrapper.new('T1A3', user_token: user_token.to_s)
@logo = Artii::Base.new font: 'colossal'
@time = Time.new
menu = Menu.new

# Searches Discogs API for random release ID based upon user input
def release_lookup(year_select, genre_select, format_select)
  algo = @auth_wrapper.search('', style: genre_select, year: year_select, format: format_select, per_page: 1,
                                  type: :release, sort: 'have', sort_order: 'dsc')
  begin
    pages = algo.pagination.items
  rescue NoMethodError => e
    if e.message["undefined method `items' for nil:NilClass"]
      $stdout.clear_screen
      puts ColorizedString['Your personal access token is invalid. Please check user/user_token.txt and try again.'].colorize(:red)
      sleep(3)
      exit
    end
  end
  pages = (pages / 2) + rand((pages / 2))
  begin
    @auth_wrapper.search('', style: genre_select, year: year_select, format: format_select, per_page: 1,
                             type: :release, sort: 'have', sort_order: 'dsc', page: pages).results.first.id
  rescue NoMethodError => e
    if e.message["undefined method `id' for nil:NilClass"]
      $stdout.clear_screen
      puts ColorizedString['No release exists with these parameters, please try something else.'].colorize(:red)
      sleep(3)
      exit
    end
  end
end

# For formatting search result to string
def release_info(id)
  wrapper = Discogs::Wrapper.new('T1A3')
  release = wrapper.get_release(id)
  "'#{release['title']}' - #{release['artists'][0]['name']}, released #{release['released_formatted']} - https://www.discogs.com/release/#{id} - #{release['styles']}"
end

# For printing search result to Terminal + 'user/digger_log.txt'
def print_result(result)
  $stdout.clear_screen
  puts 'Digger found:'
  puts '-----'
  puts result
  puts '-----'
  File.write('user/digger_log.txt', "#{@time.strftime('%Y-%m-%d %H:%M:%S')} - #{result}\n", mode: 'a')
  puts ColorizedString['Results written to user/digger_log.txt'].colorize(:yellow)
  puts '-----'
end

# Begin Digger App
$stdout.clear_screen
puts @logo.asciify('DISCOGS DIGGER').colorize(:yellow)
puts ColorizedString['Welcome to the Discogs Digger! Use this app to dig for rare and obscure records!'].colorize(:green)
puts
format_select = menu.format
genre_select = menu.genre
year_select = menu.year
id = release_lookup(year_select, genre_select, format_select)
result = release_info(id)
print_result(result)

# Menu loop
while menu

  case menu.again

  when 1
    $stdout.clear_screen
    id = release_lookup(year_select, genre_select, format_select)
    result = release_info(id)
    print_result(result)
  when 2
    $stdout.clear_screen
    format_select = menu.format
    genre_select = menu.genre
    year_select = menu.year
    id = release_lookup(year_select, genre_select, format_select)
    result = release_info(id)
    print_result(result)
  when 3
    exit
  end

end
