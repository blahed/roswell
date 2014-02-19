namespace :roswell do

  task :create_roswell_key do
    create_roswell_key
  end

  task :create_admin_user => [:environment] do
    create_admin_user
  end

  desc 'Do initial setup to get roswell up and running'
  task :setup => [:create_roswell_key, :environment] do
    create_admin_user
  end

end

def create_admin_user
  admin_user = User.where(:admin => true).first

  if admin_user
    puts "You already have an admin user, looks like roswell is already setup..."
  else
    puts "You'll need to make an admin user to get started..."
    print "Username: "
    username = STDIN.gets.chomp
    print "Password: "
    password = STDIN.gets.chomp

    User.create!(:username => username, :password => password, :admin => true)

    puts "Admin user was created, you may now login and add users & groups"
  end
end

def create_roswell_key
  key_path = File.join(Rails.root, 'config/initializers/roswell_key.rb')

  if File.exist? key_path
    puts "config/initializers/roswell_key.rb already exists"
  else
    puts "Creating config/initializers/roswell_key.rb"
    File.open(key_path, 'w') { |file| file.write("Roswell::Application.config.roswell_key = '#{SecureRandom.hex(64)}'") }
  end
end
