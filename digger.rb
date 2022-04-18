require "discogs"

wrapper = Discogs::Wrapper.new("T1A3")
auth_wrapper = Discogs::Wrapper.new("T1A3", user_token: "FAQInfIhaulwQIEXXKPePjPYAngJoezTNKJuiBFk")

#Grabs release info based on release ID number, returns release Title, Artist and Release date
def release_info(id)
  wrapper = Discogs::Wrapper.new("T1A3")
  release = wrapper.get_release(id)
  puts "'#{release['title']}' - #{release['artists'][0]['name']}, released #{release['released_formatted']}"
end

#release_info(x)

def release_lookup(term)
  auth_wrapper = Discogs::Wrapper.new("T1A3", user_token: "FAQInfIhaulwQIEXXKPePjPYAngJoezTNKJuiBFk")
  auth_wrapper.search(term, :style => 'tech house', :year => 1992, :per_page => 10, :type => :release)
end

# search = auth_wrapper.search("maas", :style => 'tech house', :per_page => 10, :type => :release)
# puts "What would you like to search for?"
# search_string = gets

puts release_lookup('voulez vous').keys

puts '------------'

puts release_lookup('airflash')['results'][0]['id']

puts '------------'

puts release_info(397017)