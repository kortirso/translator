require 'securerandom'

# represents token creation service
class TokenService
    KEY_SIZE = 32

    def self.call
        SecureRandom.hex(KEY_SIZE)
    end
end
