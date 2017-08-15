  # This file populates a database file within the db folder
  # For demonstration purposes
require 'fileutils'
require 'sequel'
require 'jwe'

  FileUtils.mkdir 'db' unless Dir.exist?('db')
  DB = Sequel.connect('sqlite://db/diabetes.sqlite3')

  # create an items table
  unless File.exist?('db/diabetes.sqlite3')
    begin
      DB.create_table :data do
        primary_key :id
        String :userid
        Number :date
        Number :time
        Number :level
      end
      DB.create_table :users do
        String :userid
        String :email
        String :key
      end
    end
    # create a dataset from the items table
    data = DB.from(:data)
    users = DB.from(:users)
    userid = 'c2155911-2bab-42b7-8a8b-8d38acbb34f1'
    key = '\x97\xCC:\v\xD0\xBFbv|]\xAA.\xFF\xCEN\x10gD\xD2\xDC\x1F|\x8B\xC8\xF8^\x94\xA3\xC9\xD8i\xBE'
    payload = userid.to_s
    encrypted = JWE.encrypt(payload, key, alg: 'dir')
    # time is in military time
    # when manually inserting data using this file follow octal literals for Dates
    data.insert(userid: userid, date: Date.new(2017, 0o4, 15), time: 741, level: 281)
    data.insert(userid: userid, date: Date.new(2017, 0o4, 15), time: 957, level: 146)
    data.insert(userid: userid, date: Date.new(2017, 0o4, 15), time: 1156, level: 208)
    data.insert(userid: userid, date: Date.new(2017, 0o4, 15), time: 1254, level: 187)
    data.insert(userid: userid, date: Date.new(2017, 0o4, 15), time: 1440, level: 304)
    data.insert(userid: userid, date: Date.new(2017, 0o4, 15), time: 1516, level: 277)
    data.insert(userid: userid, date: Date.new(2017, 0o4, 15), time: 1600, level: 210)
    data.insert(userid: userid, date: Date.new(2017, 0o4, 15), time: 1727, level: 88)
    data.insert(userid: userid, date: Date.new(2017, 0o4, 15), time: 1810, level: 68)
    data.insert(userid: userid, date: Date.new(2017, 0o4, 15), time: 2145, level: 108)
    users.insert(userid: userid, email: 'recieve.diabetesapi@gmail.com', key: encrypted)
  end
