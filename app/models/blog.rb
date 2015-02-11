class Blog < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy

  before_create :set_publish_status

  def is_publish?
    status === 'publish'
  end

  def is_draft?
    status === 'draft'
  end

  def is_pending?
    status === 'pending'
  end





private

  def set_publish_status
    self.status = 'pending'
  end



end
