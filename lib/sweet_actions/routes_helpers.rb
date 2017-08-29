def create_sweet_action(method, path, action, options = {})
  to = options.fetch(:to, "sweet_actions##{action}")

  valid_methods = %i[get post put delete]
  raise 'not a valid method' unless valid_methods.include?(method.to_sym)
  args = { to: to }.merge(options)
  send(method, path, args)
end

def create_sweet_actions(resource, options = {})
  path = options.fetch(:path, '/')
  namespace = options.fetch(:namespace, nil)
  singular = resource.to_s.singularize
  resource_class = singular.classify
  actions = %i[collect show create update destroy]
  only = options.fetch(:only, actions)
  base_path = "#{path}#{resource}"

  options = options.merge(resource_name: resource_class, namespace: namespace)

  if only.include?(:collect) || only.include?(:index)
    create_sweet_action(:get, base_path, :collect, options)
  end

  if only.include?(:show)
    create_sweet_action(:get, "#{base_path}/:id", :show, options)
  end

  if only.include?(:create)
    create_sweet_action(:post, base_path, :create, options)
  end

  if only.include?(:update)
    create_sweet_action(:put, "#{base_path}/:id", :update, options)
  end

  if only.include?(:destroy)
    create_sweet_action(:delete, "#{base_path}/:id", :destroy, options)
  end
end
