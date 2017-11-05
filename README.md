# ActsAsFootprintable
[![Build Status](https://travis-ci.org/patorash/acts_as_footprintable.png)](https://travis-ci.org/patorash/acts_as_footprintable)

Acts As Footprintable is a Ruby Gem specifically written for Rails/ActiveRecord models.
The main goals of this gem are:

- Allow any model to leave footprints
- Get access ranking for footprintable model
- Get access histories by footprinter model


## Installation

### Rails 3.2, 4.x and 5.x

Add this line to your application's Gemfile:

```ruby
gem 'acts_as_footprintable', '~> 0.5.0'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install acts_as_footprintable

### Database Migrations

Acts As Footprintable uses a footprints table to store all footprints information.
To generate and run the migration just use.

    $ rails generate acts_as_footprintable:migration
    $ rake db:migrate

## Usage

### Footprintable models

```ruby
class Post < ActiveRecord::Base
  acts_as_footprintable
end

@post = Post.create(:name => 'my post!')

@post.leave_footprints @user
@post.footprints.size # => 1
```

### Footprintable model access ranking

```ruby
# Total access ranking
total_ranking = Post.access_ranking

# Span access ranking
monthly_ranking = Post.access_ranking(1.month.ago.beginning_of_month..1.month.ago.end_of_month)

# Limit access ranking
monthly_top10_ranking = Post.access_ranking(1.month.ago.beginning_of_month..1.month.ago.end_of_month, 10)
# => {footprintable_id => count, ...}
```

### Footprinter models

```ruby
class User < ActiveRecord::Base
  acts_as_footprinter
end

@user.leave_footprints @post
@post.footprints.size # => 1
```

### Footprinter model access histories

```ruby
# Total access histories
total_access_histories = @user.access_histories
# Limited total access histories
total_access_histories = @user.access_histories(10)

# Post access histories
post_access_histories = @user.access_histories_for Post
# Limited Post access histories
post_access_histories = @user.access_histories_for(Post, 10)
```

## Testing

All tests follow the RSpec format and located in the spec directory.
They can be run with:

    $ rake spec

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
