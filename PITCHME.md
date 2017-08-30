---

# Sweet Actions
#### a Ruby on Rails Gem

---

## Let's REST not STRESS

Implementing a REST JSON API should be:

- easy
- consistent
- secure
- extendable

---

## Job to be Done

What is the Job that REST is solving?

- Users need to interact with our database
- They can do so by either creating a new record or reading, updating, or destroying an existing record (CRUD)

---

For example, given an **Events** resource:

- See an event
- See a list of events
- Create an event
- Update an event
- Delete an event

---

## The Big 5

- show
- index
- create
- update
- destroy

---

## Good News

Consistency = easy to program

...or at least it should be

---

## Current Process

We are focused on the **resource** instead of the **action**

```ruby
class EventsController
  def index; end
  def show; end
  def create; end
  def update; end
  def destroy; end
end
```

- resource = class
- actions = methods

---

## But wait...

Which do you think has more in common in terms of programming logic?

1. events#create <=> events#index
2. events#create <=> articles#create

---

```ruby
class EventsController < ApplicationController
  def create
    event = Event.new(event_params)
    raise NotAuthorized unless can?(:create, event)

    if event.save
      # success
    else
      # failure
    end
  end

  def index
    events = Event.where(date: >= Date.today)
    serialize(events)
  end
end
```

---

```ruby
class ArticlesController < ApplicationController
  def create
    article = Article.new(article_params)
    raise NotAuthorized unless can?(:create, article)

    if article.save
      # success
    else
      # failure
    end
  end

  # more similar to events#index than articles#create
  def index
    articles = Article.where(published: true)
    serialize(articles)
  end
end
```

---

## Answer: #2

````
'events#create' == 'articles#create'
```

```
'events#create' != 'events#index'
```

---

### Actions as First Class Citizens

Since the actions have more in common with each other than they do with the resources to which they belong, it is the actions that should be objects instead of the resource.

---

```ruby
class CreateAction < SweetActions::CreateAction
  def action
    resource = set_resource
    resource.save ? success : failure
  end

  private

  def set_resource
    resource_class.new(resource_params)
  end

  def resource_params
    decanter.new(params[resource_name])
  end
end
```

___