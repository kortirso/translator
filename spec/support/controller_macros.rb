# Macros for signing users in tests
module ControllerMacros
  def sign_in_user
    before do
      @current_user = create :user, :confirmed
      sign_in @current_user
    end
  end

  def sign_in_admin
    before do
      @current_user = create :user, :admin, :confirmed
      sign_in @current_user
    end
  end
end
