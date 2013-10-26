class Post < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  has_many :comments
  has_many :reposts
  has_many :hash_tags

  after_create :process_hashtags

  def process_hashtags
       hashtag_regex = /\B#\w\w+/
       text_hashtags = self.body.scan(hashtag_regex)
       text_hashtags.each do |tag|
       	 hashtag = HashTag.where(name: tag)
       	 if !hashtag.empty?
            hashtag = hashtag.first
         	 	hashtag.update_attributes(count: hashtag.count+=1)
       	 else
         	  HashTag.create name: tag, post_id: self.id, count: 1
     	   end
       end
  end

end
