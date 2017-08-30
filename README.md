# Sweet Actions

## The Idea

In a RESTful context, controller actions tend to have more in common with the same actions belonging to other resources than other actions belonging to the same resource. For example, let's say we have two resources in our app: Events and Articles.

Which do you think has more in common in terms of programming logic?

1. events#create <=> events#index
2. events#create <=> articles#create

We would argue that #2 has more in common than #1. Both events#create and articles#create need to do the following:

1. Authorize the transaction
2. Validate the data
3. Persist the new record
4. Respond with new record (if successful) or error information (if unsuccessful) in the JSON

By organizing our actions as methods inside a resource based controller like below, we don't have the opportunity to take advantage of basic Object Oriented programming concepts like Inheritance and Modules.

```ruby
class EventsController < ApplicationController
  # more similar to articles#create than events#index
  def create
    event = Event.new(event_params)
    raise NotAuthorized unless can?(:create, event)

    if event.save
      UserMailer.new_event_confirmation(event).deliver_later
      serialize(event)
    else
      serialize_errors(event)
    end
  end

  # more similar to articles#index than events#create
  def index
    events = Event.where(date: >= Date.today)
    serialize(events)
  end
end

class ArticlesController < ApplicationController
  # more similar to events#create than articles#index
  def create
    article = Article.new(article_params)
    raise NotAuthorized unless can?(:create, article)

    if article.save
      serialize(article)
    else
      serialize_errors(article)
    end
  end

  # more similar to events#index than articles#create
  def index
    articles = Article.where(published: true)
    serialize(articles)
  end
end
```

Instead, we propose a strategy that looks more like the following:

```ruby
# generic logic for create (sweet_actions gem)
module SweetActions
  class CreateAction < ApiAction
    def action
      @resource = set_resource
      authorize
      validate_and_save ? success : failure
    end

    # ...
  end
end

# app logic for create (app/actions/create_action.rb)
class CreateAction < SweetActions::CreateAction
  def set_resource
    resource_class.new(resource_params)
  end

  def authorized?
    can?(:create, resource)
  end
end

# resource logic for create (app/actions/events/create.rb)
module Events
  class Create < CreateAction
    def after_save
      UserMailer.new_event_confirmation(resource).deliver_later
    end
  end
end
```

With this structure, we essentially have three levels of abstraction:

- Generic create logic: SweetActions::CreateActions
- App create logic: CreateAction
- Resource create logic: Events::Create


As you can see, we can abstract most of the `create` logic to be shared across resources, which means you **only need to write the code that is unique about this create action vs. other create actions**.

## Default REST Actions

For a given resource...
- Collect: list items
- Create: create new item
- Show: show item
- Update: update item
- Destroy: delete item

Many of these actions have shared behavior, which we abstract for you:
- All require serialization of the resource
- Create and Update need to be able to properly respond with error information when save does not succeed
- Create and Update rely on decanted params
- All require authorization (cancancan)

## Automatic REST API

Given an Event model, one can do the following and get a basic RESTful API (assuming we have [decanter](https://github.com/launchpadlab/decanter) and [AMS](https://github.com/rails-api/active_model_serializers):

- rails g model Event name:string start_date:date
- rails g decanter Event name:string start_date:date
- rails g serializer Event name:string start_date:date
- add the new resource in routes

With that, you have the following at your disposal:

Collect: get '/events'
Create: post '/events'
Show: get '/events/:id'
Update: put '/events/:id'
Destroy: delete '/events/:id'

Each of these will respond with a consistent JSON format, including when saves don't succeed.

## Overriding Default Actions

Should you choose to override the default behavior (defined in app/sweet_actions/defaults/, ), you need only create your own action like so:

app/sweet_actions/events/collect.rb

```
module Events
  class Collect < SweetActions::CollectAction
    def set_resource
      Event.all.limit(10)
    end

    def authorized?
      can?(:read, resource)
    end
  end
end
```

app/sweet_actions/events/create.rb

```
module Events
  class Create < CreateAction
    def set_resource
      Event.new(resource_params)
    end

    def authorized?
      can?(:create, resource)
    end

    def save
      resource.save
    end

    def after_save
      SiteMailer.notify_user
    end
  end
end
```

app/sweet_actions/events/show.rb

```
module Events
  class Show < ShowAction
    def set_resource
      Event.find(params[:id])
    end

    def authorized?
      can?(:read, resource)
    end
  end
end
```

app/sweet_actions/events/update.rb

```
module Events
  class Update < UpdateAction
    def set_resource
      Event.find(params[:id])
    end

    def authorized?
      can?(:update, resource)
    end

    def save
      resource.update(resource_params)
    end
  end
end
```

app/sweet_actions/events/destroy.rb

```
module Events
  class Destroy < DestroyAction
    def set_resource
      Event.find(params[:id])
    end

    def authorized?
      can?(:destroy, resource)
    end

    def destroy
      resource.destroy
    end
  end
end
```

## Installation

### 1. Install Gem

Gemfile:

```ruby
gem 'sweet_actions'
gem 'active_model_serializers'
gem 'decanter'
```

Terminal:

```
bundle
bundle exec rails g sweet_actions:install
```

### 2. Generate Resource

```
rails g model Event title:name start_date:date
bundle exec rake db:migrate
rails g decanter Event title:name start_date:date
rails g serializer Event title:name start_date:date
rails g actions Events
```

### 3. Add Routes

```ruby
Rails.application.routes.draw do
  create_sweet_actions(:events)
end
```