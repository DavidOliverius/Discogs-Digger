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

prompt = TTY::Prompt.new
wrapper = Discogs::Wrapper.new('T1A3')
auth_wrapper = Discogs::Wrapper.new('T1A3', user_token: 'FAQInfIhaulwQIEXXKPePjPYAngJoezTNKJuiBFk')
logo = Artii::Base.new :font => 'colossal'
time = Time.new

# Returns string with release info based on release ID number: Title, Artist and Release date
def release_info(id)
  wrapper = Discogs::Wrapper.new('T1A3')
  release = wrapper.get_release(id)
  "'#{release['title']}' - #{release['artists'][0]['name']}, released #{release['released_formatted']} - https://www.discogs.com/release/#{id} - #{release['styles']}"
end

# Searches Discogs API for random release ID based upon user input 
def release_lookup(year_select, genre_select, format_select)
    auth_wrapper = Discogs::Wrapper.new('T1A3', user_token: 'FAQInfIhaulwQIEXXKPePjPYAngJoezTNKJuiBFk')
    pages = auth_wrapper.search('', style: genre_select, year: year_select, format: format_select, per_page: 1, type: :release, sort: 'have', sort_order: 'dsc').pagination.items
    pages = (pages / 4) + rand((pages / 4) * 3)
    auth_wrapper.search('', style: genre_select, year: year_select, format: format_select, per_page: 1, type: :release, sort: 'have', sort_order: 'dsc', page: pages).results.first.id
end



# def release_lookup(year_select, genre_select)
#     auth_wrapper = Discogs::Wrapper.new('T1A3', user_token: 'FAQInfIhaulwQIEXXKPePjPYAngJoezTNKJuiBFk')
#     pages = auth_wrapper.search('', style: genre_select, year: year_select, per_page: 1, type: :release, sort: 'have',
#         sort_order: 'dsc').pagination.items
#     pages / 2 + (rand(pages) / 2)
#   end

# pages = auth_wrapper.search('', style: genre, year: year, per_page: 1, type: :release, sort: 'have',
#     sort_order: 'dsc').pagination.items

# Algorithm to determine random release
# def algo(pages)
#     x = pages / 2 + (rand(pages) / 2)
# end

#
genres = ['Techno', 'House', 'Trance', 'Progressive House', 'Tech House', 'Breaks', 'Psy-Trance', 'Electro', 'Progressive Trance']

formats = {'Vinyl' => 'Vinyl', 'CD' => 'CD', 'All Formats' => ''}

$stdout.clear_screen
puts logo.asciify('DISCOGS DIGGER').colorize(:yellow)
puts ColorizedString["Welcome to the Discogs Digger! Use this app to dig for rare and obscured records!"].colorize(:magenta)
begin
  puts
  format_select = prompt.select("What format would you like?", formats, required:true)
  
  genre_select = prompt.multi_select("\nWhat genre would you like to dig for?", genres, required: true)
  genre_select = genre_select.join(", ")

  year_select = prompt.slider('Year', min: 1990, max: 2022, step: 1, default: 1990, required: true)

  id = release_lookup(year_select, genre_select, format_select)
  result = release_info(id)
  $stdout.clear_screen
  puts 'Digger found:'
  puts '-----'
  puts result
  puts '-----'

File.write("logs/digger_log.txt", "#{time.strftime("%Y-%m-%d %H:%M:%S")} - #{result}\n", mode: "a")

#Error handling for cases where releases do not exist - eg, Psy-Trance releases in 1990
rescue NoMethodError => e
  $stdout.clear_screen
  p 'No release exists with these parameters, please try something else.'
end
