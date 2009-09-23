require File.dirname(__FILE__) + "/../config/startup.rb"

db_url = "http://#{configatron.couchdb.server}:#{configatron.couchdb.port}/github_commits"
puts db_url
db = CouchRest.database!(db_url)

id = "_design/github"

design_doc = db.get(id) rescue {"_id" => id, :views => {}};

design_doc[:views][:commits_by_month] = {
  :map => "
  function(doc) {
     for(var i=0; i<doc.data.length; i++){
       var year = doc.data[i].authored_date.substring(0, 4);
       var month = doc.data[i].authored_date.substring(5, 7);
       var day = doc.data[i].authored_date.substring(8, 10);
       emit([doc.data[i].user, year, month , day, doc.data[i].repository ],  doc.data[i]);
    }
   }
",
}

db.save_doc(design_doc)
