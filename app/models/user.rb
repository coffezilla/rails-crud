class User < ApplicationRecord
    has_secure_password

    validates :name, presence: true
    validates :email, presence: true, uniqueness: true 
    validates :password, length: { minimum: 6}, allow_nil: true

    before_create :set_uuid

    private

    def set_uuid
        self.id = SecureRandom.uuid
    end
end
