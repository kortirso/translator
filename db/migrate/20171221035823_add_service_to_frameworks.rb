class AddServiceToFrameworks < ActiveRecord::Migration[5.1]
    def change
        add_column :frameworks, :service, :string, default: ''
    end
end
