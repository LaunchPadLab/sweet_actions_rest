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

## REST Job to be Done

What is the Job that REST is solving?

- Users need to interact with our database
- They can do so by either creating a new record or reading, updating, or destroying an existing record
- CRUD: create, read, update, destroy

+++

For example, given an Events resource:

- See a list of events
- See details about an event
- Create an event
- Update an event
- Delete an event

+++

## Good News

Concise, consistent requirements.

This should be easy for us programmers.

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

- EventsController is the class (e.g. resource)
- Each action is just a method (not extendable like a class or shareable like a module)

---

## But wait...

Which do you think has more in common in terms of programming logic?

1. events#create <=> events#index
2. events#create <=> articles#create

+++

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
