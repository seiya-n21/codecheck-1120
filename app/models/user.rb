class User < ActiveRecord::Base
  belongs_to :room
  has_one :match
  delegate :status, to: :room, prefix: true

  validates :name, length: { in: 2..10 }
  validates :gender, inclusion: { in: %w(male female) }
  validates :status, inclusion: { in: [true, false] }
  # validates :room_id, presence: true

  after_save :update_room

  private

  def update_room
    count = User.where(room_id: self.room_id, status: true).group(:gender).count
    self.room.male = count['male'] || 0
    self.room.female = count['female'] || 0

    room_num = self.room.male + self.room.female
    if self.room.status == 1 && (room_num == Settings.room.capacity * 2)
      self.room.status = 2
    end

    self.room.save
  end
end
