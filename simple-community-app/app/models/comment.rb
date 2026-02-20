class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, presence: true

  def is_reply?
    commentable_type == "Comment"
  end

  def parent_comment
    commentable if is_reply?
  end
end
