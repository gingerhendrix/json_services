
np_namespace "echonest" do |ns|
  
  ns.route 'artist_audio', [:id] do |id|
    artist = EchoNest::Artist.new id
    audio = artist.get_audio
    audio
  end
  
  ns.route 'artist_search', [:query] do |query|
    EchoNest::ArtistSearch.search query
  end
end
