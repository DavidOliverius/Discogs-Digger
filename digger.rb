require 'discogs'
require 'tty-prompt'
require 'colorized_string'

# Disables Deprecated warning from Discogs-wrapper
$VERBOSE = nil

# Disables Hashie error logs from output
Hashie.logger.level = Logger.const_get 'ERROR'

prompt = TTY::Prompt.new
wrapper = Discogs::Wrapper.new('T1A3')
auth_wrapper = Discogs::Wrapper.new('T1A3', user_token: 'FAQInfIhaulwQIEXXKPePjPYAngJoezTNKJuiBFk')

# Grabs release info based on release ID number, returns release Title, Artist and Release date
def release_info(id)
  wrapper = Discogs::Wrapper.new('T1A3')
  release = wrapper.get_release(id)
  "'#{release['title']}' - #{release['artists'][0]['name']}, released #{release['released_formatted']}"
end

def release_lookup(term, year, genre)
  auth_wrapper = Discogs::Wrapper.new('T1A3', user_token: 'FAQInfIhaulwQIEXXKPePjPYAngJoezTNKJuiBFk')
  auth_wrapper.search(term, style: genre, year: year, per_page: 10, type: :release, sort: 'have',
                            sort_order: 'dsc').results.first.id
end

genres = ['Techno', 'Trance', 'Progressive House', 'Tech House', 'Breaks', 'Psy-Trance']

puts ColorizedString['
    8888888b. 8888888 .d8888b.   .d8888b.   .d88888b.   .d8888b.   .d8888b.     8888888b. 8888888 .d8888b.   .d8888b.  8888888888 8888888b.
    888  "Y88b  888  d88P  Y88b d88P  Y88b d88P" "Y88b d88P  Y88b d88P  Y88b    888  "Y88b  888  d88P  Y88b d88P  Y88b 888        888   Y88b
    888    888  888  Y88b.      888    888 888     888 888    888 Y88b.         888    888  888  888    888 888    888 888        888    888
    888    888  888   "Y888b.   888        888     888 888         "Y888b.      888    888  888  888        888        8888888    888   d88P
    888    888  888      "Y88b. 888        888     888 888  88888     "Y88b.    888    888  888  888  88888 888  88888 888        8888888P"
    888    888  888        "888 888    888 888     888 888    888       "888    888    888  888  888    888 888    888 888        888 T88b
    888  .d88P  888  Y88b  d88P Y88b  d88P Y88b. .d88P Y88b  d88P Y88b  d88P    888  .d88P  888  Y88b  d88P Y88b  d88P 888        888  T88b
    8888888P" 8888888 "Y8888P"   "Y8888P"   "Y88888P"   "Y8888P88  "Y8888P"     8888888P" 8888888 "Y8888P88  "Y8888P88 8888888888 888   T88b
'].colorize(:yellow)
puts ColorizedString["\nWelcome to the Discogs Digger! Use this app to dig for rare and obscured records!"].colorize(:magenta)
begin
  genre_select = prompt.select("\nWhat genre would you like to dig for?", genres, required: true)

  year_select = prompt.slider('Year', min: 1990, max: 2022, step: 1, default: 1990, required: true)

  id = release_lookup('', year_select, genre_select)

  puts 'Digger found:'
  result = release_info(id)

  puts '-----'

  puts result

  puts '-----'
# Error handling for cases where releases do not exist - eg, Psy-Trance releases in 1990
rescue NoMethodError => e
  p 'No release exists with these parameters, please try something else.'
end
