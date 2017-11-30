# Sweet Actions

## Introduction
Controller actions (`events#create`) tend to have more in common with their cousins (`articles#create`) than their siblings (`events#show`). Because of this, we think actions should be classes instead of methods. This makes it easier to use common Object Oriented principles like Inheritance and Composition.

The end result of this approach is that resource-specific controllers and actions often don't even need to exist - their logic is abstracted to parent actions.

Work smart not hard right?

Let's take a look at how that's possible.

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

### 4. Profit

```
rails s
```

Using Postman, submit the following request:

POST to localhost:3000/api/v1/events

```json
{
  "event": {
    "title": "My sweet event",
    "start_date": "01/18/2018"
  }
}
```

You should get a response like so:

```json
{
  "type": "event",
  "attributes": {
    "id": 1,
    "title": "My sweet event",
    "start_date": "2018-01-18"
  }
}
```

## Default REST Actions

For a given resource, we provide five RESTful actions:

```
Collect: GET '/events'
Create: POST '/events'
Show: GET '/events/:id'
Update: PUT '/events/:id'
Destroy: DELETE '/events/:id'
```

Many of these actions have shared behavior, which we abstract for you:
- Authorization of resource (cancancan for example)
- Create and Update need to be able to properly respond with error information when save does not succeed
- Create and Update rely on decanted params
- Serialization of resource

## Creating One-Off Actions

For actions that are not RESTful (i.e. not one of the five listed above), you can still use `sweet_actions`. For example, let's say you want to create the action `events#export`.

1. Create a new file at app/actions/events/export.rb:
2. Implement `action` method that responds with a response hash
3. Create the route

```ruby
# app/actions/events/export.rb:
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

```ruby
# config/routes.rb
Rails.application.routes.draw do
  scope :api
    scope :v1
      get '/events/export' => 'sweet_actions#export', resource_class: 'Event'
    end
  end
end
```

Using a tool like Postman, submit the following request:

```
GET to localhost:3000/api/v1/events/export
```

You should get a response like so:

```json
{
  success: true
}
```

## The Idea Explained in Detail

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

```ruby
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
```

```ruby
# app logic for create (app/actions/create_action.rb)
class CreateAction < SweetActions::JSON::CreateAction
  def set_resource
    resource_class.new(resource_params)
  end

  def authorized?
    can?(:create, resource)
  end
end
```

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

As you can see, we can abstract most of the `create` logic to be shared across resources, which means you **only need to write the code that is unique about this create action vs. other create actions**.

