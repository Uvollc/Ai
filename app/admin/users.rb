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

  controller do
    def destroy
      @user = User.find(params[:id])
      @user.soft_delete

      redirect_to admin_users_path
    end
  end
end
