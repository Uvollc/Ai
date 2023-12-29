ActiveAdmin.register User do
  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :phone
    column :created_at
    column :updated_at
    column :payment_status
    column :deleted_at
    actions
  end
end
