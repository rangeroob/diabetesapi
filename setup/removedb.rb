require 'fileutils'

FileUtils.remove_entry_secure('db/diabetes.sqlite3')
FileUtils.remove_entry_secure('db/')
