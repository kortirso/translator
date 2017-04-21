class TranslationsController < ApplicationController
    def index
        @locale_list = Locale.all.collect { |loc| loc.code }
    end
end
