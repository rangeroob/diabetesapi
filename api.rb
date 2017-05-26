require 'cuba'
require 'cuba/safe'
require 'rack/protection'
require 'json'
require 'date'
require 'time'
require 'sequel'
require 'mail'

Cuba.use Rack::Session::Cookie, secret: Random.new_seed.to_s
Cuba.use Rack::Protection
Cuba.use Rack::Protection::RemoteReferrer
Cuba.plugin Cuba::Safe
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

class EmailData < Cuba; end
EmailData.define do
  on root, param('address') do |address|
    res.headers['Content-Type'] = 'text/html; charset=utf-8'
    res.write "email sent to #{address}"
    options = { address: 'smtp.gmail.com',
                port: 587,
                domain: 'gmail.com',
                user_name: 'test.diabetesapi@gmail.com',
                password: 'isdunbfipxjeksph',
                authentication: 'plain',
                enable_starttls_auto: true }
    Mail.defaults do
      delivery_method :smtp, options
    end
    Mail.deliver do
      to address.to_s
      from 'test.diabetesapi@gmail.com'
      subject 'Diabetes Data'
      body data.all.to_json
    end
  end
end

Cuba.define do
  @version = 'v1'
  on get do
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

    on "#{@version}/email" do
      run EmailData
    end
  end
end
