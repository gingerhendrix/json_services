require File.dirname(__FILE__) + "/../config/startup.rb"

db_url = "http://#{configatron.couchdb.server}:#{configatron.couchdb.port}/github_commits"
puts db_url
db = CouchRest.database!(db_url)

id = "_design/github"

design_doc = db.get(id) rescue {"_id" => id, :views => {}};

design_doc[:views][:commit_counts_by_month] = design_doc[:views][:commits_by_month]
design_doc[:views][:commits_by_month] = nil

db.save_doc(design_doc)
