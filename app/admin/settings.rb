ActiveAdmin.register Setting do
  actions :index, :show, :edit, :update
  permit_params :value

  form do |f|
    inputs do
      f.input :value, label: f.object.name.humanize
    end
    f.actions
  end
end
