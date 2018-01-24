class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :access_token
end
