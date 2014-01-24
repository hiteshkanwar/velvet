class Message < ActiveRecord::Base
  attr_accessible :ancestry, :message_text, :sender_id,:receiver_id,:is_trash,:parent_id,:attachments_attributes
  has_ancestry
  belongs_to :receiver ,:class_name=>"User",:foreign_key=>:receiver_id
  belongs_to :sender ,:class_name=>"User",:foreign_key=>:sender_id
  has_many :attachments, :as => :attachable ,:class_name=>'Attachment'
  accepts_nested_attributes_for :attachments ,allow_destroy: true

  scope :not_trash,lambda{where("is_trash"=>false)}
  scope :trash_messages,lambda{where("is_trash"=>true)}
  

  def move_to_trash
    self.is_trash = true
    self.save
  end
  
  def undelete
    self.is_trash = false
    self.save
  end

  def is_sent_by?(user)
    sender_id == user.id
  end
end
