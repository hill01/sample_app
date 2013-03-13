# == Schema Information
#
# Table name: microposts
#
#  id            :integer          not null, primary key
#  content       :string(255)
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  reply_at_user :integer
#

class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}

  before_save :reply_to

  #DESC is Sql for 'descending', newest posts have the largest timestamp
  default_scope order: 'microposts.created_at DESC'

  #not being used
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
			WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
	user_id: user.id)
  end

  def self.from_users_followed_by_and_replying_at(user)
    followed_user_ids = "SELECT followed_id FROM relationships
			WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id OR 
		reply_at_user = :user_id", user_id: user.id)
  end

  def reply_to
    if match = /\A@\S+/.match(content)
      at_email = match[0]
      email = at_email[1..-1]
      other_user = User.find_by_email(email)
      self.reply_at_user = other_user.id if other_user
    end      
  end
end
