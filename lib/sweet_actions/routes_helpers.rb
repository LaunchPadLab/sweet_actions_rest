def create_sweet_actions(resource, options = {})
  path = options.fetch(:path, '/')
  namespace = options.fetch(:namespace, nil)
  singular = resource.to_s.singularize
  resource_class = singular.classify

  options = options.merge(resource_name: resource_class, namespace: namespace)

  get "#{path}#{resource}", { to: 'sweet_actions#collect' }.merge(options)
  get "#{path}#{resource}/:id", { to: 'sweet_actions#show' }.merge(options)
  post "#{path}#{resource}", { to: 'sweet_actions#create' }.merge(options)
  put "#{path}#{resource}/:id", { to: 'sweet_actions#update' }.merge(options)
  delete "#{path}#{resource}/:id", { to: 'sweet_actions#destroy' }.merge(options)
end