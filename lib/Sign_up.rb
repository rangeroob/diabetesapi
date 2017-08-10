
module Api
  class Signup < Cuba; end
  Sequel.connect('sqlite://db/diabetes.sqlite3', max_connections: 200)
  users = DB.from(:users)
  Signup.define do
    on root, param('email') do |email|
      res.headers['Content-Type'] = 'text/html; charset=utf-8'
      # key = OpenSSL::PKey::RSA.generate(2048)
      userid = SecureRandom.uuid
      key = ENV['key']
      payload = userid.to_s
      encrypted = JWE.encrypt(payload, key, alg: 'dir')
      users.insert(userid: userid.to_s, email: email.to_s, key: encrypted.to_s) unless users.first(email: email.to_s)
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
        to email.to_s
        from 'test.diabetesapi@gmail.com'
        subject 'Diabetes API Key'
        body users.first(userid: userid.to_s).to_json
      end
      res.write "signed up #{email}"
    end
  end
end
