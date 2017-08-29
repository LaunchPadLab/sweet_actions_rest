class DestroyAction < SweetActions::DestroyAction
  def set_resource
    resource_class.find(params[:id])
  end

  def authorized?
    # can?(:destroy, resource)
    false
  end

  def destroy
    resource.destroy
  end
end
