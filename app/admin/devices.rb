ActiveAdmin.register Device do
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
      row :user
      row :platform
      row :last_seen
      row :is_dev_device
      row :name
      row :app
      row :push_token
      row :created_at
      row :updated_at
    end
  end

  member_action :send_test_push, method: :post do
    if resource.push_token.nil?
      redirect_to "/admin/devices/#{resource.id}", notice: "No push token"
    else
      NotificationService.send_message "Testing push token", resource
      redirect_to "/admin/devices/#{resource.id}", notice: "Test sent"
    end
  end

  action_item :test_push, only: :show  do
    link_to "Test Push", "#{resource.id}/send_test_push", method: :post
  end

end
