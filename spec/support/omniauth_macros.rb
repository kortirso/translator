# Macros for testing omniauth controllers
module OmniauthMacros
  def facebook_hash
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      'provider' => 'facebook',
      'uid' => '123545',
      'info' => {
        'email' => 'example_facebook@xyze.it',
        'name' => 'Alberto Pellizzon',
        'first_name' => 'Alberto',
        'last_name' => 'Pellizzon',
        'image' => ''
      },
      'extra' => {
        'raw_info' => {}
      }
    )
  end

  def facebook_invalid_hash
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      'provider' => 'facebook',
      'uid' => '123545',
      'info' => {
        'name' => 'Alberto Pellizzon',
        'first_name' => 'Alberto',
        'last_name' => 'Pellizzon',
        'image' => ''
      },
      'extra' => {
        'raw_info' => {}
      }
    )
  end

  def github_hash
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      'provider' => 'github',
      'uid' => '123545',
      'info' => {
        'name' => 'Alberto Pellizzon',
        'email' => 'example_facebook@xyze.it',
        'nickname' => 'AlbertoPellizzon'
      },
      'extra' => {
        'raw_info' => {}
      }
    )
  end

  def github_invalid_hash
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      'provider' => 'github',
      'uid' => '123545',
      'info' => {
        'name' => 'Alberto Pellizzon',
        'nickname' => 'AlbertoPellizzon'
      },
      'extra' => {
        'raw_info' => {}
      }
    )
  end
end
