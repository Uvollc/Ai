ActiveAdmin.register User do
  remove_filter :avatar_attachment, :avatar_blob, :cpics_attachments, :cpics_blobs
  permit_params :first_name, :last_name, :phone, :deleted_at, :payment_status

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
