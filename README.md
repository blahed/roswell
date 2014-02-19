# Roswell

Roswell is a simple rails app that allows you to share passwords, notes, and software licenses with select groups of people.



![Account Screenshot](https://github.com/downloads/blahed/roswell/screenshot.png)

### Features

* Four types of: generic accounts, web accounts, licenses, and notes
* Unified search
* Simple user and group management
* Organize items by one or more groups
* Restrict users to only certain groups
* A favorites list for frequently used entries
* Single click copy-to-clipboard

### How secure is Roswell it?

Not extremely secure, but more secure than a shared google spreadsheet. Passwords are encrypted server-side before they are stored in mongo. The key to decrypt is stored on the server, so if your server is compromised, the passwords could be compromised. The `production` environment requires SSL, this is to ensure that cleartext passwords aren't sent/received over the wire.

### How can it be more secure?

Client-side encryption seems to be a popular solution, but can be complex to implement and a little cumbersome to use. The hope was to figure out the UI and the workflow for creating/sharing/grouping/retrieving passwords, and then figure out how to make it more secure. Really, we just needed something better than a spreadsheet.

## Installing Roswell

Roswell is just a rails app so clone it down somewhere and:

    > bundle              # install gem dependencies
    > rake roswell:setup  # create your encryption key file and an admin user

Then just start your choice of server (you'll wanna put it behind SSL).


## Create & configure for Heroku

	> gem install heroku
	> heroku create example-roswell --stack cedar
	> heroku addons:add mongolab:starter
	> heroku config:add HEROKU=true
	> heroku config:add ROSWELL_KEY=`ruby -r securerandom -e "puts SecureRandom.hex(64)"`
	> git push heroku master
	> heroku run rake roswell:create_admin_user


## Dependencies

* Ruby 1.9
* MongoDB

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request