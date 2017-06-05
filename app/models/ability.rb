class Ability
    include CanCan::Ability

    attr_reader :user

    def initialize(user)
        @user = user
        if user
            case user.role
                when 'admin' then admin_abilities
                when 'translator' then translator_abilities
                when 'subscriber' then subscriber_abilities
                else user_abilities
            end
        else
            guest_abilities
        end
    end

    def guest_abilities
        can :read, :all
    end

    def user_abilities
        guest_abilities

        can :create, Request
    end

    def subscriber_abilities
        user_abilities
    end

    def translator_abilities
        guest_abilities
    end

    def admin_abilities
        can :manage, :all
    end
end
