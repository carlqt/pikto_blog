class Comment < ActiveRecord::Base
  # Associations
  belongs_to :blog
  belongs_to :user

  # Callbacks
  before_create :set_status

  # Validations
  validates :message, :blog, :user, presence: true

  delegate :email, to: :user, prefix: true

  # Scope
  scope :blog_comments, ->(id) { where.not(blog_id: nil).where(blog_id: id)}

  private
  def set_status
    self.status = 'pending'
  end

end
