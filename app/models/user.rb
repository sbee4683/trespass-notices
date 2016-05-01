class User < ActiveRecord::Base
    attr_accessor :reset_token
    
    before_save { email.downcase! }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@englewoodgov.org/
    validates(:name, presence: true, uniqueness: true)
    validates(:username, presence: true, uniqueness: true)
    validates(:email, presence: true, format: { with: VALID_EMAIL_REGEX, 
        message: "Only City of Englewood emails allowed" }, 
        uniqueness: { case_sensitive: false })
    validates(:usertype, presence: true)
    has_secure_password
    validates(:password, presence: true, length: { minimum: 6 }, allow_nil: true)
    
    def self.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
    
    def User.new_token
        SecureRandom.urlsafe_base64
    end
    
    def create_reset_digest
        self.reset_token = User.new_token
        update_attribute(:reset_digest, User.digest(reset_token))
        update_attribute(:reset_sent_at, Time.zone.now)
    end
    
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end
    
    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end
end
