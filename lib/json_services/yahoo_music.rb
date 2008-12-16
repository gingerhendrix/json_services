
Yahoo::Music.app_id = "dZNdsfnV34H1.YJ.PosESLzFECBVZX0I5SCge6P1QKTagX3jrzoc5vCSgUfYzjannxjjsQ--" #[Your App ID Here]

np_namespace "yahoo_music" do |ns|
    ns.route 'videos', [:artist] do |name|
      artist = Yahoo::Music::Artist.new(name)
      {:videos => artist.videos}
    end
    
    ns.route 'video', [:id] do |id|
      Yahoo::Music::Video.new id.to_i
    end
end
