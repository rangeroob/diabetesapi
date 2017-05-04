require 'cuba'
require 'rack/protection'
require 'json'
require 'date'
require 'time'
require 'sequel'

Cuba.use Rack::Session::Cookie, secret: Random.new_seed.to_s
Cuba.use Rack::Protection
Cuba.use Rack::Protection::RemoteReferrer
DB = Sequel.connect('sqlite://db/diabetes.sqlite3', max_connections: 200)

data = DB[:data]

Cuba.define do
  on get do
    on root do
      res.redirect '/all'
    end

    on 'all' do
      res.headers['Conent-Type'] = 'application/json; charset=utf-8'
      res.write data.all.to_json
    end

    on 'avg' do
      res.headers['Conent-Type'] = 'application/json; charset=utf-8'
      res.write data.avg(:level).to_json
    end

    # example address localhost:9292/add?d=2017-04-15&t=1507&l=120
    # where ?d= equals the date YYYY-MM-DD &t= Time in Military Format
    # then &l= the Blood Sugar Level

    on 'add', param('d'), param('t'), param('l') do |d, t, l|
      res.headers['Conent-Type'] = 'application/json; charset=utf-8'
      data.insert(date: d.to_s, time: t.to_s, level: l.to_s)
      res.write data.all.to_json
    end

    on 'rm', param('d'), param('t'), param('l') do |d, t, l|
      res.headers['Conent-Type'] = 'application/json; charset=utf-8'
      data.where(date: d.to_s, time: t.to_s, level: l.to_s).delete
      res.write data.all.to_json
    end
  end
end
