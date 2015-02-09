class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  has_many :blogs

  before_create :set_default_type

  def is_admin?
    type === 'Admin'
  end

  def is_editor?
    type === 'Editor'
  end

  def is_teacher?
    type === 'Teacher'
  end

  def is_student?
    type === 'Student'
  end

  def is_owner?( klass )
    if klass.class.model_name === 'Blog'
      id === klass.user_id
    elsif klass.class.model_name === 'Comment'
      id === klass.user_id
    else
      false
    end
  end

  private

  def set_default_type
    self.becomes(Student)
  end

end
