# Filtron

Filtron was built to work with [Ransack](https://github.com/ernie/ransack).
Ransack uses search predicates to simplify searching and querying your model
data. Filtron aims to alias these predicates so your URLs are a little
less ugly when filtering your data via GET requests. Take this URL for example:

    http://example.com/users?user[first_name_eq]=Lee&user[email_cont]=@gmail

    # Controller:
    def index
      @users = User.search(params[:user]).result
    end

Wouldn't this be nicer?

    http://example.com/users?name=Lee&email=@gmail

    # Controller:
    def index
      @users = User.filter(params)
    end

## Installation

Add this line to your application's Gemfile:

    gem 'filtron'

## Usage

You can easily add Filtron to your existing models

```ruby
class User < ActiveRecord::Base
  filter_with :fname, :first_name_eq
  filter_with :lname, :last_name_eq
  filter_with :country, :address_country_name_eq do |code|
    Country.find_by_code(code).name
  end

  queries :first_name, :email
end
```

Now in your controller:

```ruby
def index
  @users = User.filter(params)
end
```

`params` might look something like this:

```ruby
{
  fname: "Lee",
  country: "gb",
  q: "@gmail.com",
  something: "else"
}
```

This will translate into the following Ransack predicates:

```ruby
{
  first_name_eq: "Lee",
  address_country_name_eq: "Great Britain",
  first_name_or_email_cont: "@gmail.com"
}
```

Filtron will then use these predicates to search for and return a result.

By default, `queries` will use `params[:q]` for a general query. You can
change this in the call to `queries`:

```
queries :first_name, :last_name, :email, with: :search
```

Now, `/users?search=foo` will use these query predicates.
