class Post < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  has_many :comments
  has_many :reposts
  has_many :hash_tags
  has_many :admires
  has_one :media
  mount_uploader :avatar, DocumentUploader
  process_in_background :avatar

  validates_length_of :body, maximum: 170

  after_create :process_hashtags
  after_create :process_media

  def process_hashtags
       hashtag_regex = /\B#\w\w+/
       text_hashtags = self.body.to_s.scan(hashtag_regex)
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

  def process_media
    
    media_regex = /(?:.be\/|\/watch\?v=|\/(?=p\/))([\w\/\-]+)/
    media_urls = self.body.to_s.scan(media_regex).flatten
    
    if !media_urls.blank?  
      media_urls.each do |youtube|
        self.media = Media.create(name: "YouTube", url: "//www.youtube.com/embed/#{youtube}")
        break
      end
    end
    media1 = /(?:http:\/\/)?(?:www\.)?(?:youporn\.com)\/(?:watch)?(.+)/
    media_urls = self.body.to_s.scan(media1).flatten
    
    if !media_urls.blank?  
      media_urls.each do |youtube|
        self.media = Media.create(name: "YouPorn", url: "//www.youporn.com/embed#{youtube}")
        break
      end
    end 
    media2 = /(?:http:\/\/)?(?:www\.)?(?:redtube\.com)\/(?:watch)?(.+)/
    media_urls = self.body.to_s.scan(media2).flatten
    if !media_urls.blank? 
      media_urls.each do |youtube|
        self.media = Media.create(name: "RedTube", url: "//embed.redtube.com/player/?id=#{youtube}&style=redtube")
        break
      end
    end
    media3 = /(?:http:\/\/)?(?:www\.)?(?:pornhub\.com)\/(?:watch)?(.+)/
    media_urls = self.body.to_s.scan(media3).flatten
    if !media_urls.blank? 
      media_urls.each do |youtube|
        youtube= youtube.gsub('view_video.php?viewkey=','')
        self.media = Media.create(name: "PornHub", url: "//www.pornhub.com/embed/#{youtube}")
        break
      end
    end
  end

end
