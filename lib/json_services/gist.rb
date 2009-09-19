
np_namespace 'gist' do |ns|

   ns.route "gists", [:username] do |username|
     res = Net::HTTP.get_response(URI.parse("http://gist.github.com/api/v1/json/gists/#{username}"))
     gists = JSON.parse(res.body)
   end

end
