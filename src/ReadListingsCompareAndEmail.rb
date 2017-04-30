#!/usr/bin/ruby

# Script to gather events from google calendar API, load into SQLite Database and email results.
require 'net/smtp'
require 'rubygems'
require 'date'
require 'nokogiri'
require 'open-uri'

# Save input parameters.
username = ARGV[0]
password = ARGV[1]
sendTo = ARGV[2].split(",")
searchUrl = ARGV[3]
scriptDir = File.dirname(__FILE__)

puts "Getting new listings."

currPage = Nokogiri::HTML(open(searchUrl))
listings = "<table>#{currPage.css('tr')}</table>"

puts "Comparing to existing listing."
prevListings = File.read("#{scriptDir}/../data/previousListings.txt")

if prevListings == listings
	puts "No change to listings. Exiting."
	exit
end

File.open("#{scriptDir}/../data/previousListings.txt", 'w') { |file| file.write(listings) }

puts "Creating email."
message = <<MESSAGE_END
From: Listing Watcher <ListingWatcher>
To:  Listing Watcher <ListingWatcher>
MIME-Version: 1.0
Content-type: text/html
Subject: New Listing - #{Time.now().strftime("%Y-%m-%d")}

<h3>Listings Have Changed</h3>
Check listings at #{searchUrl}
<br/>
<br/>
<h3>Current Listings</h3>
#{listings}

MESSAGE_END

puts "Sending email."
smtp = Net::SMTP.new 'smtp.gmail.com', 587
smtp.enable_starttls
smtp.start("YourDomain", "#{username}@gmail.com", password, :login) do
        smtp.send_message(message, "listingwatcher", sendTo )

puts "Done."
end
