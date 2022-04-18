require "discogs"

wrapper = Discogs::Wrapper.new("T1A3")

# auth_wrapper = Discogs::Wrapper.new("T1A3", user_token: "FAQInfIhaulwQIEXXKPePjPYAngJoezTNKJuiBFk")


# search = auth_wrapper.search(artist_search, :per_page => 10, :type => :artist)
# artist = wrapper.get_artist("10649353")

# puts "Please enter artist name:"
# artist_search = gets
# puts search

# release = wrapper.get_release(21824347)
# release = wrapper.get_release(1)
# puts "-------------"

# puts release.keys

# puts "-------------"

# puts "#{release['title']} - #{release['artists'][0]['name']} - #{release['released_formatted']}"

def release_info(id)
  wrapper = Discogs::Wrapper.new("T1A3")
  release = wrapper.get_release(id)
  puts "#{release['title']} by #{release['artists'][0]['name']}, released #{release['released_formatted']}"
end

release_info(5)