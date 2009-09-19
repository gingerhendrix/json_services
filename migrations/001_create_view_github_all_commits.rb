require File.dirname(__FILE__) + "/../config/startup.rb"

db_url = "http://#{configatron.couchdb.server}:#{configatron.couchdb.port}/github_commits"
puts db_url
db = CouchRest.database!(db_url)

db.save_doc({
  "_id" => "_design/github", 
  :views => {
       :all_commits => {
           :map => "function(doc) {\n   for(var i=0; i<doc.data.length; i++){\n    emit([doc.data[i].user, doc.data[i].authored_date], doc.data[i]);\n  }\n }"
       }
    }
  })
