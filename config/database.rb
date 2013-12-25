# Filename: config/database.rb
# Directory: /Users/abruzzim/Documents/ga_wdi/projects/blog
# Author: Mario Abruzzi
# Date: 16-Dec-2013
# Desc: Week 03 - Day 01 - HW
#
# PSQL Database Connection Parameters
ActiveRecord::Base.establish_connection(
    :adapter  => "postgresql",
    :host     => "localhost",
    :username => "abruzzim",
    :database => "bwain_db",
    :encoding => "utf8"
)
#
