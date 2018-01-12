ActiveAdmin.register Film do
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

  index do
    column :title
    column :running_time
    column :created_at
    column :updated_at
    column :posters do |film|
      film.posters.count
    end

    actions
  end

  action_item :flixster_data, only: :show do
    link_to 'Flixster Data', "#{resource.id}/flixster_data"
  end

  show do
    attributes_table do
      row :title
      row :synopsis
      row :running_time
      row :theater_release_date
      row :created_at
      row :updated_at
      row :posters do |film|
        film.posters.count
      end
    end

    panel "Posters" do
      table_for film.posters do
        column :url
        column :width
        column :height
      end
    end
  end

  filter :title, as: :string
  filter :running_time
  filter :created_at
  filter :updated_at
  filter :poster_count, as: :numeric
end

class Film
  ransacker :poster_count do
    Arel.sql("(SELECT COUNT(*) FROM posters WHERE posters.film_id = films.id)")
  end
end