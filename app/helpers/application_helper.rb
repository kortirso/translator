# Helpers for app
module ApplicationHelper
  def change_locale(locale)
    url_for(request.params.merge(locale: locale))
  end
end
