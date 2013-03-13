class AddReplyAtUserToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :reply_at_user, :integer
  end
end
