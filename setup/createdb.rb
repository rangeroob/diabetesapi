require 'fileutils'
require 'sequel'

# This file populates a database file within the db folder
# For demonstration purposes

FileUtils.mkdir 'db' unless Dir.exist?('db')
DB = Sequel.connect('sqlite://db/diabetes.sqlite3')

# create an items table
begin
  DB.create_table :data do
    primary_key :id
    Number :date
    Number :time
    Number :level
  end
end
# create a dataset from the items table
data = DB[:data]
data.insert(id: 1)
# time is in military time
# when manually inserting data using this file follow octal literals for Dates
data.insert(date: Date.new(2017, 0o4, 15), time: 741, level: 281)
data.insert(date: Date.new(2017, 0o4, 15), time: 957, level: 146)
data.insert(date: Date.new(2017, 0o4, 15), time: 1156, level: 208)
data.insert(date: Date.new(2017, 0o4, 15), time: 1254, level: 187)
data.insert(date: Date.new(2017, 0o4, 15), time: 1440, level: 304)
data.insert(date: Date.new(2017, 0o4, 15), time: 1516, level: 277)
data.insert(date: Date.new(2017, 0o4, 15), time: 1600, level: 210)
data.insert(date: Date.new(2017, 0o4, 15), time: 1727, level: 88)
data.insert(date: Date.new(2017, 0o4, 15), time: 1810, level: 68)
data.insert(date: Date.new(2017, 0o4, 15), time: 2145, level: 108)
