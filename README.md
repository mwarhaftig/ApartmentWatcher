## Apartment Listing Watcher

Fairly custom script to check leasing company's listings, see if any new listings have been added, and if so, email new listings via Gmail to interested parties.

#### Required Gems:
* `gem install nokogiri` - http://www.nokogiri.org

#### Run command (Cron saved in 'config/PrivateRunCommand.cron'):
`./src/ReadListingsCompareAndEmail.rb <<Gmail_Account_Name>> <<Gmail_Password>> <<Send_Email_To>> <<Listing_URL_To_Check>>`