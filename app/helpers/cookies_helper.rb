# Helper for cookies authentification
module CookiesHelper
  # Remembers a person in a persistent session.
  def remember(person)
    person.remember
    cookies.permanent.signed[:person_id] = person.id
    cookies.permanent.signed[:person_type] = person.class.to_s
    cookies.permanent[:remember_token] = person.remember_token
  end

  # Forgets a person in a persistent session.
  def forget(person)
    person.forget
    cookies.delete(:person_id)
    cookies.delete(:person_type)
    cookies.delete(:remember_token)
  end

  # returns logged user, creates/returns guest, logges remembered person
  def current_person
    return current_user if user_signed_in?
    return create_guest if cookies.signed[:person_type] != 'User' && cookies.signed[:person_type] != 'Guest'
    person = cookies.signed[:person_type].constantize.find_by(id: cookies.signed[:person_id])
    return create_guest unless person.try(:authenticated?, cookies[:remember_token])
    return person if person.is_a?(Guest)
    sign_in(person)
    @current_user = person
  end

  # Create guest user
  def create_guest
    guest = Guest.create
    remember(guest)
    guest
  end
end
