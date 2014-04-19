require 'faker'

# Create 15 topics for which the posts will belong to.
topics = []
15.times do
  topics << Topic.create(
    name: Faker::Lorem.sentence, 
    description: Faker::Lorem.paragraph
  )
end

# Create 5 users with their own posts
5.times do
  password = Faker::Lorem.characters(10)
  user = User.new(
    name: Faker::Name.name, 
    email: Faker::Internet.email, 
    password: password, 
    password_confirmation: password)
  user.skip_confirmation!
  user.save

  # Note: by calling `User.new` instead of `create`,
  # we create an instance of a user which isn't saved to the database.
  # The `skip_confirmation!` method sets the confirmation date
  # to avoid sending an email. The `save` method updates the database.

  #Create 5 to 10 posts for each user that is created.
  rand(5..10).times do
    topic = topics.first
    post = Post.create(
      user: user,
      title: Faker::Lorem.sentence, 
      body: Faker::Lorem.paragraph,
      topic: topic)
    # set the created_at to a time within the past year
    post.update_attribute(:created_at, Time.now - rand(600..31536000))

    topics.rotate!
  end

  #Create
end

user = User.first
user.skip_reconfirmation!
user.update_attributes(email: ENV['BLOCCIT_DEFAULT_EMAIL'], password: ENV['BLOCCIT_DEFAULT_PASS'], password_confirmation: ENV['BLOCCIT_DEFAULT_PASS'], name: ENV['BLOCCIT_DEFAULT_NAME'])

# Create an admin user
admin = User.new(
  name: 'Admin User',
  email: 'admin@example.com', 
  password: ENV['BLOCCIT_DEFAULT_PASS'], 
  password_confirmation: ENV['BLOCCIT_DEFAULT_PASS'])
admin.skip_confirmation!
admin.save
admin.update_attribute(:role, 'admin')

# Create a moderator
moderator = User.new(
  name: 'Moderator User',
  email: 'moderator@example.com', 
  password: ENV['BLOCCIT_DEFAULT_PASS'], 
  password_confirmation: ENV['BLOCCIT_DEFAULT_PASS'])
moderator.skip_confirmation!
moderator.save
moderator.update_attribute(:role, 'moderator')

# Create a member
member = User.new(
  name: 'Member User',
  email: 'member@example.com', 
  password: ENV['BLOCCIT_DEFAULT_PASS'], 
  password_confirmation: ENV['BLOCCIT_DEFAULT_PASS'])
member.skip_confirmation!
member.save

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"

