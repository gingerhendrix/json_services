
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
      return {:repositories => []}
     end
     info = JSON.parse res.body  
     repos = info['data']['repositories'].map {|repo| {:name => repo['name'] } }
     repos.each do |repo|
      res = get "commits", :username => username, :repo => repo[:name]
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
     
   #  repos = repos.sort do |r1, r2|
   #      r1['name'] <=> r2['name']
   #   end
     repos = repos.sort do |r1, r2|
       c1 = (r1 && r1['last_commit'] && r1['last_commit']['authored_date']) ? r1['last_commit']['authored_date'] : nil;
       c2 = (r2 && r2['last_commit'] && r2['last_commit']['authored_date']) ? r2['last_commit']['authored_date'] : nil;
       if c1.nil?
         1
       elsif c2.nil?
        -1  
       else
        c2 <=> c1
       end
     end
     {:repositories => repos}     
  end  
  
  ns.route "all_commits_by_month", [:username, :year, :month] do |username, year, month|
    #TODO 1. could this be rewritten by adding the doc to the key and using groupLevel=2 and no reduce function
    #TODO 2. this should also sort by date - 1.1.1 should accomplish this
    month = month.rjust(2, '0')
    db = database("github", "commits")
    db.view "github/commits_by_month", :startkey => [username, year, month, {}], :endkey => [username, year, month], :descending => [true]
  end
  
  ns.route "all_commit_counts_by_month", [:username] do |username|
    db = database("github", "commits")
    db.view "github/commit_counts_by_month", :group => true, :group_level => 3, :startkey => [username], :endkey => [username, {}]
  end
  
  ns.route "commit_counts_by_month", [:username, :project] do |username, project|
    db = database("github", "commits")
    db.view "github/commit_counts_by_month", :group => true, :group_level => 3, :startkey => [username, project], :endkey => [username, project, {}]
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
