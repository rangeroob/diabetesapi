require 'cuba/test'
require './api.rb'
scope do
  test do
    get '/'
    follow_redirect!
    assert last_response.body

    get 'v1/avg?database=diabetes'
    assert_equal '187.7', last_response.body

    get 'v1/all?database=diabetes'
    assert_equal '[{"id":1,"date":null,"time":null,"level":null},{"id":2,"date":"2017-04-15","time":741,"level":281},{"id":3,"date":"2017-04-15","time":957,"level":146},{"id":4,"date":"2017-04-15","time":1156,"level":208},{"id":5,"date":"2017-04-15","time":1254,"level":187},{"id":6,"date":"2017-04-15","time":1440,"level":304},{"id":7,"date":"2017-04-15","time":1516,"level":277},{"id":8,"date":"2017-04-15","time":1600,"level":210},{"id":9,"date":"2017-04-15","time":1727,"level":88},{"id":10,"date":"2017-04-15","time":1810,"level":68},{"id":11,"date":"2017-04-15","time":2145,"level":108}]', last_response.body

    get 'v1/add?database=diabetes&d=2017-05-04&t=1300&l=90'
    assert '[{"id":1,"date":null,"time":null,"level":null},{"id":2,"date":"2017-04-15","time":741,"level":281},{"id":3,"date":"2017-04-15","time":957,"level":146},{"id":4,"date":"2017-04-15","time":1156,"level":208},{"id":5,"date":"2017-04-15","time":1254,"level":187},{"id":6,"date":"2017-04-15","time":1440,"level":304},{"id":7,"date":"2017-04-15","time":1516,"level":277},{"id":8,"date":"2017-04-15","time":1600,"level":210},{"id":9,"date":"2017-04-15","time":1727,"level":88},{"id":10,"date":"2017-04-15","time":1810,"level":68},{"id":11,"date":"2017-04-15","time":2145,"level":108},{"id":12,"date":"2017-05-04,"time":1300,"level":90}]', last_response.body

    get 'v1/rm?database=diabetes&d=2017-05-04&t=1300&l=90'
    assert_equal '[{"id":1,"date":null,"time":null,"level":null},{"id":2,"date":"2017-04-15","time":741,"level":281},{"id":3,"date":"2017-04-15","time":957,"level":146},{"id":4,"date":"2017-04-15","time":1156,"level":208},{"id":5,"date":"2017-04-15","time":1254,"level":187},{"id":6,"date":"2017-04-15","time":1440,"level":304},{"id":7,"date":"2017-04-15","time":1516,"level":277},{"id":8,"date":"2017-04-15","time":1600,"level":210},{"id":9,"date":"2017-04-15","time":1727,"level":88},{"id":10,"date":"2017-04-15","time":1810,"level":68},{"id":11,"date":"2017-04-15","time":2145,"level":108}]', last_response.body

    get 'v1/edit?database=diabetes&id=2&d=2017-04-16&t=800&l=5000'
    assert_equal '[{"id":1,"date":null,"time":null,"level":null},{"id":2,"date":"2017-04-16","time":800,"level":5000},{"id":3,"date":"2017-04-15","time":957,"level":146},{"id":4,"date":"2017-04-15","time":1156,"level":208},{"id":5,"date":"2017-04-15","time":1254,"level":187},{"id":6,"date":"2017-04-15","time":1440,"level":304},{"id":7,"date":"2017-04-15","time":1516,"level":277},{"id":8,"date":"2017-04-15","time":1600,"level":210},{"id":9,"date":"2017-04-15","time":1727,"level":88},{"id":10,"date":"2017-04-15","time":1810,"level":68},{"id":11,"date":"2017-04-15","time":2145,"level":108}]', last_response.body
    # revert modified data
    get 'v1/edit?database=diabetes&id=2&d=2017-04-15&t=741&l=281'
    assert_equal '[{"id":1,"date":null,"time":null,"level":null},{"id":2,"date":"2017-04-15","time":741,"level":281},{"id":3,"date":"2017-04-15","time":957,"level":146},{"id":4,"date":"2017-04-15","time":1156,"level":208},{"id":5,"date":"2017-04-15","time":1254,"level":187},{"id":6,"date":"2017-04-15","time":1440,"level":304},{"id":7,"date":"2017-04-15","time":1516,"level":277},{"id":8,"date":"2017-04-15","time":1600,"level":210},{"id":9,"date":"2017-04-15","time":1727,"level":88},{"id":10,"date":"2017-04-15","time":1810,"level":68},{"id":11,"date":"2017-04-15","time":2145,"level":108}]', last_response.body

    get 'v1/email?address=receive.diabetesapi@gmail.com&database=diabetes'
    assert_equal 'email sent to receive.diabetesapi@gmail.com', last_response.body

    get 'v1/database?create=test'
    assert_equal 'Database test created', last_response.body
  end
end
