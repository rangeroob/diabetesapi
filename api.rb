require 'cuba'
require 'cuba/render'
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

class AllData < Cuba; end
AllData.define do
  on root do
    res.headers['Content-Type'] = 'application/json; charset=utf-8'
    res.write data.all.to_json
  end
end

class AvgLevel < Cuba; end
AvgLevel.define do
  on root do
    res.headers['Content-Type'] = 'application/json; charset=utf-8'
    res.write data.avg(:level).to_json
  end
end

class AddData < Cuba; end
AddData.define do
  on root, param('d'), param('t'), param('l') do |d, t, l|
    res.headers['Content-Type'] = 'application/json; charset=utf-8'
    data.insert(date: d.to_s, time: t.to_s, level: l.to_s)
    res.write data.all.to_json
  end
end

class RemoveData < Cuba; end
RemoveData.define do
  on root, param('d'), param('t'), param('l') do |d, t, l|
    res.headers['Content-Type'] = 'application/json; charset=utf-8'
    data.where(date: d.to_s, time: t.to_s, level: l.to_s).delete
    res.write data.all.to_json
  end
end

class EditData < Cuba; end
EditData.define do
  on root, param('id'), param('d'), param('t'), param('l') do |id, d, t, l|
    res.headers['Content-Type'] = 'application/json; charset=utf-8'
    data.where(id: id.to_s).update(date: d.to_s, time: t.to_s, level: l.to_s)
    res.write data.all.to_json
  end
end

Cuba.define do
  on get do
    @version = 'v0'
    on root do
      res.redirect("#{@version}/all")
    end

    on "#{@version}/all" do
      run AllData
    end

    on "#{@version}/avg" do
      run AvgLevel
    end

    on "#{@version}/add" do
      run AddData
    end

    on "#{@version}/rm" do
      run RemoveData
    end

    on "#{@version}/edit" do
      run EditData
    end
  end
end
