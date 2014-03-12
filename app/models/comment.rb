class Comment < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :post

    mount_uploader :avatar, DocumentUploader
  process_in_background :avatar
end
