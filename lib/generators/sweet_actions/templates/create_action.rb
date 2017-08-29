class CreateAction < SweetActions::CreateAction
  def set_resource
    resource_class.new(resource_params)
  end

  def authorized?
    # can?(:create, resource)
    false
  end

  def save
    resource.save
  end
end
