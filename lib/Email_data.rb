
module EmailData
  class EmailData < Cuba; end
  EmailData.define do
    on root, param('address'), param('database') do |address, database|
      DB = Sequel.connect("sqlite://db/#{database}.sqlite3", max_connections: 200)
      data = DB[:data]
      res.headers['Content-Type'] = 'text/html; charset=utf-8'
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
      res.write "email sent to #{address}"
    end
  end
end
