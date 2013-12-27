class Photo < ActiveRecord::Base
  belongs_to :user
  mount_uploader :image, PhotoUploader

  def self.find_flex(from, direction, limit)
    q = self.includes(:user)
    if from.nil? || from.blank?
      q = q.order('created_at DESC')
    else
      q = q.where('id != ?', from) if from.to_i > 0
      if direction.nil?
        q = q.where('id > ?', from.to_i).order('created_at DESC')
      elsif direction == 'up'
        q = q.where('id > ?', from.to_i).order('created_at ASC')
      elsif direction == 'down'
        q = q.where('id < ?', from.to_i).order('created_at DESC')
      end
    end
    q = q.where('image != ""')
    q.limit(limit)
  end
end
