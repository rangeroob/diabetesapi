
module Api
  class EmailData < Cuba; end
  Sequel.connect('sqlite://db/diabetes.sqlite3', max_connections: 200)
  data = DB.from(:data)
  users = DB.from(:users)
  EmailData.define do
    on root, param('address'), param('key') do |address, key|
      begin
        authorize_user = JWE.decrypt(key, ENV['key'])
        res.headers['Content-Type'] = 'text/html; charset=utf-8'
        options = { address: 'smtp.gmail.com',
                    port: 587,
                    domain: 'gmail.com',
                    user_name: ENV['email'],
                    password: ENV['emailpassword'],
                    authentication: 'plain',
                    enable_starttls_auto: true }
        Mail.defaults do
          delivery_method :smtp, options
        end
        Mail.deliver do
          to address.to_s
          from ENV['email']
          subject 'Diabetes Data'
          body data.where(userid: users.select(authorize_user)).all.to_json
        end
        res.write "email sent to #{address}"
      rescue
        res.status = 401
        res.write('Not authorized')
      end
    end
  end
end
