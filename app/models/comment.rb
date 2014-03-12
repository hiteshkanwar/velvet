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

    media_urls.each do |youtube|
    	
      self.media = Media.create(name: "YouTube", url: "//www.youtube.com/embed/#{youtube}")
      break
    end

  end
end
