ActiveAdmin.register User do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  show do
    attributes_table do
      row :username
      row :last_seen
      row :created_at
      row :updated_at
      row :devices do |user|
        user.devices.count
      end
      row :ratings do |user|
        user.rated_list.count
      end
      row :want_to_watches do |user|
        user.want_to_watch_list.count
      end
    end

    panel 'Devices' do
      table_for user.devices do
        column :platform
      end
    end

    panel 'Ratings' do
      table_for user.rated_list do
        column :film do |watch|
          link_to watch.film.title, "/admin/films/#{watch.film.id}"
        end
        column :rating do |watch|
          watch.rating
        end
        column :comment
        column :created_at
        column :updated_at
      end
    end
  end

end
