class Friendship < ApplicationRecord
  belongs_to :member
  belongs_to :friend, class_name: 'Member', foreign_key: :friend_id

  validates :member_id, :friend_id, presence: true

  after_commit :create_inverse_friendship, on: :create
  after_commit :remove_inverse_friendship, on: :destroy

  # def friend
  #   Member.find(self.friend_id)
  # end

  def inverse_friendship
    Friendship.find_by(member_id: self.friend_id, friend_id: self.member_id)
  end

  def create_inverse_friendship
    # This could be put into a background job if time allows
    unless self.inverse_friendship
      Friendship.create(member_id: self.friend_id, friend_id: self.member_id)
    end
  end

  def remove_inverse_friendship
    # This could be put into a background job if time allows
    if self.inverse_friendship
      self.inverse_friendship.destroy
    end
  end
end
