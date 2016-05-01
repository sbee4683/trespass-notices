class Trespass < ActiveRecord::Base
    validates :caseNum, presence: true, length: { minimum: 7 }
    validates :locationName, presence: true
    validates :locationAddr, presence: true
    validates :subjName, presence: true
    validates :subjDOB, presence: true
    validates :dateOfNotification, presence: true
    
    def self.search(params)
        if params[:archived]
            where("subjName LIKE ? AND LocationName LIKE ? AND locationAddr LIKE ?",
            "%#{params[:name]}%", "%#{params[:location]}%", "%#{params[:address]}%")
        else
            where("subjName LIKE ? AND LocationName LIKE ? AND locationAddr LIKE ? AND archived LIKE ?",
            "%#{params[:name]}%", "%#{params[:location]}%", "%#{params[:address]}%", false)
        end
    end
end
