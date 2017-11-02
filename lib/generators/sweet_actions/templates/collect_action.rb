class CollectAction < SweetActions::JSON::CollectAction
  def set_resource
    resource_class.all
  end

  def authorized?
    # can?(:read, resource)
    false
  end
end
