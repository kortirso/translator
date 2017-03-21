class TranslationsController < ApplicationController
    def index
        @tasks = Task.for_guest(session[:guest])
    end
end
