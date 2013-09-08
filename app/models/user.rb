class User < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :posts
  has_many :comments
  
  validates_uniqueness_of :email
  validates_presence_of :email, :name, :hashed_password
  validates :email, email: true
  validates :name, length: { minimum: 5 }
  validates :hashed_password, length: { minimum: 6 }

  after_create :default_profile_url
  after_create :hash_password 

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
