class Comment < ActiveRecord::Base
  belongs_to :blog
  before_create :set_status


  private
  def set_status
    self.status = 'pending'
  end

end
