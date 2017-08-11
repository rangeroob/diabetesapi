
module Api
  class AvgLevel < Cuba; end
  Sequel.connect('sqlite://db/diabetes.sqlite3', max_connections: 200)
  data = DB.from(:data)
  users = DB.from(:users)
  AvgLevel.define do
    on root, param('key') do |key|
      begin
        authorize_user = JWE.decrypt(key, ENV['key'])
        res.headers['Content-Type'] = 'application/json; charset=utf-8'
        res.write data.where(userid: authorize_user).avg(:level).to_json
      rescue
        res.status = 401
        res.write('Not authorized')
      end
    end
  end
end
