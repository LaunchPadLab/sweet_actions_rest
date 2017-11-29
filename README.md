# Sweet Actions

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
rails g model Event title:string start_date:date
bundle exec rake db:migrate
rails g decanter Event title:string start_date:date
rails g serializer Event title:string start_date:date
rails g actions Events
```

### 3. Add Routes

```ruby
Rails.application.routes.draw do
  scope :api
    scope :v1
      create_sweet_actions(:events)
    end
  end
end
```

### Profit

```
rails s
```

Using Postman, submit the following request:

POST to localhost:3000/api/v1/events

```
{
  "event": {
    "title": "My sweet event",
    "start_date": "01/18/2018"
  }
}
```

You should get a response like so:

{
  "type": "event",
  "attributes": {
    "id": 1,
    "title": "My sweet event",
    "start_date": "2018-01-18"
  }
}

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

Rails pushes us to organize our actions as methods inside a resource based controller like below. With this approach we cannot take advantage of basic Object Oriented programming concepts like Inheritance and Modules as it relates to specific actions.

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

Instead, we propose a strategy where the actions themselves are classes. This would allow us have multiple layers of abstraction like so:

1. **Generic Logic** (logic that applies to all apps that use SweetActions):
- `class SweetActions::JSON::CreateAction`

2. **Application Logic**: logic that applies to all create actions in your app:
- `class CreateAction < SweetActions::JSON::CreateAction`

3. **Resource Logic**: logic that applies to a specific resource (e.g. Events) in your app
- `class Events::Create < CreateAction`

With this approach, we often won't even need to implement resource specific actions. This is because by default our `Events::Create` action will inherit all the functionality it needs. Only when there are deviances from the norm do we implement resource specific classes and in those cases, we need only override the methods that correspond with the deviance.

For example, let's say we want to send an email when an event is created. It's as easy as overriding the `after_save` hook:

```ruby
# resource logic for create (app/actions/events/create.rb)
module Events
  class Create < CreateAction
    def after_save
      UserMailer.new_event_confirmation(resource).deliver_later
    end
  end
end
```

If we wanted to override all action behavior, we could just implement the `action` method itself:

```ruby
module Events
  class Create < CreateAction
    def action
      event = Event.new(resource_params)
      event.save ? success(event) : failure
    end

    def success(event)
      UserMailer.new_event_confirmation(resource).deliver_later
      { success: true, data: { event: event } }
    end
  end
end
```

Under the hood, this is made possible by a structure that looks like the following:

# generic logic for create (sweet_actions gem)
module SweetActions
  module JSON
    class CreateAction < BaseAction
      def action
        @resource = set_resource
        authorize
        validate_and_save ? success : failure
      end

      # ...
    end
  end
end

# app logic for create (app/actions/create_action.rb)
class CreateAction < SweetActions::JSON::CreateAction
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

## Creating One-Off Actions

Create a new file at app/actions/events/export.rb:

```ruby
module Events
  class Export < SweetActions::JSON::BaseAction
    def action
      {
        success: true
      }
    end
  end
end
```

Create the route:

```ruby
Rails.application.routes.draw do
  scope :api
    scope :v1
      get '/events/export' => 'sweet_actions#export', resource_class: 'Event'
    end
  end
end
```

Using Postman, submit the following request:

GET to localhost:3000/api/v1/events/export

You should get a response like so:

{
  success: true
}