require "discogs"
require "tty-prompt"

# Disables Hashie error logs from output
Hashie.logger.level = Logger.const_get 'ERROR'

prompt = TTY::Prompt.new
wrapper = Discogs::Wrapper.new("T1A3")
auth_wrapper = Discogs::Wrapper.new("T1A3", user_token: "FAQInfIhaulwQIEXXKPePjPYAngJoezTNKJuiBFk")

class Response < Hashie::Mash
    disable_warnings
  end

#Grabs release info based on release ID number, returns release Title, Artist and Release date
def release_info(id)
  wrapper = Discogs::Wrapper.new("T1A3")
  release = wrapper.get_release(id)
  puts "'#{release['title']}' - #{release['artists'][0]['name']}, released #{release['released_formatted']}"
end

#release_info(x)

# def release_lookup(term)
#   auth_wrapper = Discogs::Wrapper.new("T1A3", user_token: "FAQInfIhaulwQIEXXKPePjPYAngJoezTNKJuiBFk")
#   auth_wrapper.search(term, :style => 'tech house', :year => 1992, :per_page => 10, :type => :release)
# end


def release_lookup(term, year, genre)
    auth_wrapper = Discogs::Wrapper.new("T1A3", user_token: "FAQInfIhaulwQIEXXKPePjPYAngJoezTNKJuiBFk")
    auth_wrapper.search(term, :style => genre, :year => year, :per_page => 10, :type => :release, :sort => "have", :sort_order => "dsc").results.first.id
  end

# search = auth_wrapper.search("maas", :style => 'tech house', :per_page => 10, :type => :release)
# puts "What would you like to search for?"
# search_string = gets

# puts release_lookup('voulez vous').keys

# puts '------------'

# puts release_lookup('airflash')['results'][0]['id']

# puts '------------'

# puts release_info(397017)


begin
    puts "
    ██████╗░██╗░██████╗░█████╗░░█████╗░░██████╗░░██████╗  ██████╗░██╗░██████╗░░██████╗░███████╗██████╗░
    ██╔══██╗██║██╔════╝██╔══██╗██╔══██╗██╔════╝░██╔════╝  ██╔══██╗██║██╔════╝░██╔════╝░██╔════╝██╔══██╗
    ██║░░██║██║╚█████╗░██║░░╚═╝██║░░██║██║░░██╗░╚█████╗░  ██║░░██║██║██║░░██╗░██║░░██╗░█████╗░░██████╔╝
    ██║░░██║██║░╚═══██╗██║░░██╗██║░░██║██║░░╚██╗░╚═══██╗  ██║░░██║██║██║░░╚██╗██║░░╚██╗██╔══╝░░██╔══██╗
    ██████╔╝██║██████╔╝╚█████╔╝╚█████╔╝╚██████╔╝██████╔╝  ██████╔╝██║╚██████╔╝╚██████╔╝███████╗██║░░██║
    ╚═════╝░╚═╝╚═════╝░░╚════╝░░╚════╝░░╚═════╝░╚═════╝░  ╚═════╝░╚═╝░╚═════╝░░╚═════╝░╚══════╝╚═╝░░╚═╝
    "
    puts "Welcome to the Discogs Digger!"
    genres = ["Techno", "Trance", "Progressive House", "Tech House", "Breaks", "Psy-Trance"]
    genre_select = prompt.select("What genre would you like to dig for?", genres)

    year_select = prompt.slider("Year", min: 1990, max: 2022, step: 1, default: 1990)

    id = release_lookup('', year_select, genre_select)
    puts release_info(id)
rescue NoMethodError => e
    p "No such release exists with these parameters, please try something else."
    retry
    
end

# puts auth_wrapper.search('wiggle', :style => 'tech house', :year => 1996, :per_page => 10, :type => :release)['results'][0]['id']
# puts "------"
# puts auth_wrapper.search('', :style => 'techno' && 'trance', :year => 1996, :per_page => 10, :type => :release, :sort => "have", :sort_order => "dsc").results.first.id
