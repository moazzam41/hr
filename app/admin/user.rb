ActiveAdmin.register User do
permit_params :role ,:name, :email, :password, :password_confirmation
  actions :all
  menu priority: 1
index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :role
    column :name
    actions
  end

  filter :name
  filter :email

  form do |f|
    f.inputs "User Details" do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :role
    end
    f.actions
  end

end

