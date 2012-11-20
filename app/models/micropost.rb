class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}

  #DESC is Sql for 'descending', newest posts have the largest timestamp
  default_scope order: 'microposts.created_at DESC'
end
