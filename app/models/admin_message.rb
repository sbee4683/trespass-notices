class AdminMessage < ActiveRecord::Base
    validates :msg, presence: true, uniqueness: true
    validates :msgType, presence: true
end
