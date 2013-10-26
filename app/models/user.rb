class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not valid")
    end
  end
end

class User < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :posts, order:'created_at DESC'
  has_many :comments
  has_many :likes
  has_many :reposts, order:'created_at DESC'
  has_many :followers, :class_name => 'Followings', :foreign_key => 'user_id'
  has_many :following, :class_name => 'Followings', :foreign_key => 'follower_id'
  
  validates_uniqueness_of :email, :username
  validates_presence_of :email, :username, :hashed_password
  validates :email, email: true
  validates :username, length: { minimum: 5 }
  validates :hashed_password, length: { minimum: 6 }
  validates_exclusion_of :username, :in => %w( messages posts blog forum admin profile dashboard comment landing )

  after_create :hash_password

  def all_posts(pg=1)
    (self.posts << self.reposts.map(&:post_id).map {|id| Post.find(id) })
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
