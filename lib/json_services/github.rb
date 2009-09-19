
np_namespace "github" do |ns|
  ns.route 'user_info', [:username], {:cache_expiry => 24.hours} do |username|
    GitHub::API.user(username)
  end
  
  ns.route "commits", [:username, :repo], {:cache_expiry => 24.hours} do |username, repo|
    GitHub::API.commits(username, repo)
  end
  
  ns.route "commit", [:username, :repo, :id], {:cache_expiry => 24.hours} do |username, repo, id|
    GitHub::API.commit(username, repo, id)
  end

  ns.route "repos_with_recent_commits", [:username] do |username|
     res = get "user_info", :username => username
     if res.code != '200'
      @response.partial!
      return
     end
     info = JSON.parse res.body  
     repos = info['data']['repositories'].map {|repo| {:name => repo['name'] } }
     repos.each do |repo|
      res = get "commits", :username => username, :repo => repo[:name]
#     repo['commits_reponse'] = res
      if res.code == '200'
        begin
          commits = JSON.parse res.body 
          repo['last_commit'] = commits['data'].first
        rescue
          @response.partial!
        end
     else
        @response.partial!
      end
     end
     {:repositories => repos}     
  end  

  # github/all_commits map function:
  # function(doc) {
  #   for(var i=0; i<doc.data.length; i++){
  #     emit([doc.data[i].user, doc.data[i].authored_date], doc.data[i]);
  #   }
  # }
  ns.route "all_commits", [:username], {:cache_expiry => 30.seconds} do |username|
    db = database("github", "commits")
    db.view "github/all_commits", :startkey => [username, {}], :endkey => [username], :descending=> true
  end
end
