
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
end
