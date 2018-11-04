ActiveAdmin.register Project do
permit_params :name, :description, :owner, :due_date, :status
  actions :all
  menu priority: 3

index do
    selectable_column
    id_column
    column :name
    column :description
    column :manager ,:owner
    column :due_date
    column :status
    actions
  end


  filter :name

  form do |f|
    f.inputs "Admin Details" do
      f.input :name
      f.input :description
      f.input :owner
      f.input :due_date
      f.input :status
    end
    f.actions
  end

end
