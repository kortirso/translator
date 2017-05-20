module ApplicationHelper
    def change_locale(locale)
        url_for(request.params.merge(locale: locale))
    end

    def other_translations_for_word(translation, locale)
        translations = translation.base.select_translations(locale)
        translations.delete(translation.result.text)
        if translations.size > 0
            content_tag(:div, content_tag(:p, "#{t('task.translations')}: #{translations.keys.join(', ')}"), class: 'columns small-6 small-offset-6 additional_translations')
        end
    end
end
