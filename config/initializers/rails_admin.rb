RailsAdmin.config do |config|
    config.authenticate_with do
        warden.authenticate! scope: :user
    end

    config.authorize_with do
        redirect_to main_app.root_path unless current_user.editor?
    end

    config.model Locale do
        list do
            field :id
            field :code
            field :country_code
            field :names
        end
    end

    config.model Task do
        list do
            field :id
            field :uid
            field :status
            field :from
            field :to
            field :file
        end
    end

    config.model Translation do
        list do
            field :id
            field :direction
            field :base
            field :result
        end
    end

    config.actions do
        dashboard
        index
        new
        export
        bulk_delete
        show
        edit
        delete
        show_in_app

        ## With an audit adapter, you can add:
        # history_index
        # history_show
    end
end