class Comment < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :post
  has_one :media
    mount_uploader :avatar, DocumentUploader
  process_in_background :avatar

  after_create :process_media

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
