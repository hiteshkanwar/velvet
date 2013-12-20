class Attachment < ActiveRecord::Base
  attr_accessible :attachable_id, :attachable_type, :document,:document_cache
  mount_uploader :document, DocumentUploader
  belongs_to :attachable, :polymorphic => true  
end
