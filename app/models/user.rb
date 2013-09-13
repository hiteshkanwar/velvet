class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not valid")
    end
  end
end

class User < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :posts
  has_many :comments
  
  validates_uniqueness_of :email, :username
  validates_presence_of :email, :username, :hashed_password
  validates :email, email: true
  validates :name, length: { minimum: 5 }
  validates :hashed_password, length: { minimum: 6 }
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
