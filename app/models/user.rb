class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not valid")
    end
  end
end

class User < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessor :assigned_posts
  # Handle image uploads
  mount_uploader :avatar, DocumentUploader
  mount_uploader :header, DocumentUploader

  has_many :posts, order:'created_at DESC'
  has_many :comments
  has_many :emojis
  has_many :likes
  has_many :admires
  has_many :activities
  has_many :reposts, order:'created_at DESC'
  has_many :followers, :class_name => 'Followings', :foreign_key => 'user_id'
  has_many :following, :class_name => 'Followings', :foreign_key => 'follower_id'
  has_many :messages, :class_name => 'Message', :foreign_key => 'receiver_id'
  has_many :send_messages, :class_name => 'Message', :foreign_key => 'sender_id'
  
  
  validates_uniqueness_of :email, :username
  validates_presence_of :email, :username, :hashed_password
  validates :email, email: true
  validates :username, length: { minimum: 5 }
  validates :hashed_password, length: { minimum: 6 }
  validates_exclusion_of :username, :in => %w( messages posts blog forum admin profile dashboard comment landing @ # )

  after_create :hash_password

  def all_posts(pg=1)
    @assigned_posts ||= begin
      posts = Array.new
      posts << self.posts  + self.reposts.map(&:post_id).map {|id| Post.find(id) }
      posts.flatten.sort{|a, b| b[:created_at] <=> a[:created_at]}
    end
  end 

  def followings_posts(pg=1)
    followings = self.following
    followings += [Followings.new(user_id: self.id)] # Include myself to followings but don't create
    posts = followings.map { |following| following.user.posts.find(:all, :order => "created_at desc", :limit => 50) }.flatten
    posts.sort{|a, b| b[:created_at] <=> a[:created_at]}

  end

  # People user is following
  def is_following
    self.following.map { |f| f.user }.compact
  end

  # User followers
  def is_followers
    self.followers.map { |f| f.follower }.compact
  end

  def who_to_follow
    # Get 20 random ids from who user is currently following
    people_user_following_ids = self.following.sort_by { rand }.slice(0, 20).map(&:user_id)
    # Find those users
    people_user_following = User.where(id: people_user_following_ids)
    # Find 5 random friends of friends 
    friends_of_friends = people_user_following.map { |person| 
      person.following.sort_by { rand }.slice(0, 5).map{ |friend| "#{friend.user_id}, #{friend.follower_id}" }
    }.flatten

    return friends_of_friends
    
  end
  def user_name
    "#{self.name} @#{self.username}"
  end

  private
  def self.password_match?(password="", user)
      user.hashed_password == Digest::SHA1.hexdigest(password)
  end

  private
  def self.authenticate(email="", password="")
      user = User.find_by_email(email)
      if user && User.password_match?(password, user)
         return user
      else
           return false
      end
    end

  private 
  def hash_password
    self.hashed_password = Digest::SHA1.hexdigest(self.hashed_password)
    self.save
  end
end
