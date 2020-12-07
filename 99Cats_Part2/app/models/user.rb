class User < ApplicationRecord
    validates :user_name, :password_digest, :session_token, presence: true
    validates :user_name, :session_token, uniqueness: true
    validates :password, length: {minimum: 6}, allow_nil: true 

    after_initialize :ensure_session_token

    attr_reader :password

    def self.find_by_credentials(user_name, password)
        user = User.find_by(user_name: user_name)
        return nil unless user && user.is_password?(password)
    end

    def reset_session_token!
        self.update!(session_token: self.class.generate_session_token)
        self.session_token
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def self.generate_session_token
        SecureRandom::urlsafe_base64(64)
    end

    def is_password?(password)
        bcrypt_password = BCrypt::Password.new(self.password_digest)
        bcrypt_password.is_password?(password)
    end

    def ensure_session_token
        self.session_token ||= User.generate_session_token #same as self.class.generate_session_token
    end




end
