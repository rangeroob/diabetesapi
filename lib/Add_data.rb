
module Api
  class AddData < Cuba; end
  DB = Sequel.connect('sqlite://db/diabetes.sqlite3', max_connections: 200)
  data = DB.from(:data)
  users = DB.from(:users)
  AddData.define do
    on root, param('key'), param('d'), param('t'), param('l') do |key, d, t, l|
      begin
        authorize_user = JWE.decrypt(key, ENV['key'])
        res.headers['Content-Type'] = 'application/json; charset=utf-8'
        data.insert(userid: authorize_user.to_s, date: d.to_s, time: t.to_s, level: l.to_s)
        # res.write data.whereall.to_json
        res.write data.where(userid: users.select(authorize_user)).all.to_json
      rescue
        res.status = 401
        res.write('Not authorized')
      end
    end
  end
end
