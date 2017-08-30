class UpdateAction < SweetActions::UpdateAction
  def set_resource
    resource_class.find(params[:id])
  end

  def authorized?
    # can?(:update, resource)
    false
  end

  def save
    resource.attributes = resource_params
    resource.save
  end
end
