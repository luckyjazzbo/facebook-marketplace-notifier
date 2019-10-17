require 'rubygems'
require 'bundler'
require 'uri'
Bundler.require(:default)

queries = [
  'board book',
]

headers = {
  'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2'
}

db = SQLite3::Database.new './database.db'

db.execute <<-SQL
  create table if not exists posts (
    url varchar(1024),
    created_at int
  );
SQL

posts = db.execute <<-SQL
  select *
  from posts
  order by created_at desc
  limit 100
SQL

regexp = %r{
  object\-fit:\s+cover;width:\s+inherit;height:\s+inherit"></div><img\s+src="([^"]+)"
  .*?
  style="display:\s+inline;text\-decoration:\s+"\s+id="[^"]+"><span>([\$0-9.,freeFREE]+)</span>
  .*?
  font\-weight:\s+300;font\-size:\s+12px"\s+id="[^"]+"\s+data\-nt="NT:BOX_3_CHILD">([^<]+)<
}xm

queries.each do |query|
  # response = HTTParty.get "https://m.facebook.com/marketplace/vancouver/kids/?query=#{URI.encode query}", headers: headers
  # response.body.scan regexp

  content = File.read('./body.html')
  matches = content.scan regexp
  puts matches.length
  puts matches.inspect
end
