# Heroicons::ViewComponent

A Rails gem that provides ViewComponent components for [Heroicons](https://heroicons.com/), making it easy to use Heroicons SVG icons in your Rails applications.

## Features

- 🎨 **Two Variants**: Support for both outline and solid icon styles
- 📏 **Multiple Sizes**: 16px, 20px, and 24px icon sizes
- ⚡ **Performance**: Lazy-loading with intelligent caching for optimal performance
- 🎯 **Type Safety**: Validates icon names, variants, and sizes
- 🎨 **Customizable**: Merge custom CSS classes and HTML attributes
- 🔒 **Thread-Safe**: Thread-safe caching implementation

## Installation

Add this line to your application's Gemfile:

```ruby
gem "heroicons-view-components"
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install heroicons-view-components
```

## Prerequisites

- Ruby >= 3.2.0
- Rails (for ViewComponent)
- ViewComponent >= 4.0

## Usage

### Basic Usage

Render a Heroicon in your views or components:

```erb
<%= render Heroicons::ViewComponent::Icon.new(name: "academic-cap", variant: "outline") %>
```

### Variants

Heroicons come in two variants:

- `outline` - 24x24 icons with strokes (default)
- `solid` - 20x20 icons with fills

```erb
<!-- Outline icon (default) -->
<%= render Heroicons::ViewComponent::Icon.new(name: "home") %>

<!-- Solid icon -->
<%= render Heroicons::ViewComponent::Icon.new(name: "home", variant: "solid") %>
```

### Sizes

You can specify a size for icons (16, 20, or 24):

```erb
<!-- Outline icon for 24px -->
<%= render Heroicons::ViewComponent::Icon.new(name: "home", variant: "outline", size: "24") %>

<!-- Solid icon for 20px -->
<%= render Heroicons::ViewComponent::Icon.new(name: "home", variant: "solid", size: "20") %>
```

### Custom HTML Attributes

Pass additional HTML attributes including CSS classes:

```erb
<!-- Single class -->
<%= render Heroicons::ViewComponent::Icon.new(
  name: "user",
  variant: "outline",
  class: "w-6 h-6 text-gray-500"
) %>

<!-- Multiple classes (array) -->
<%= render Heroicons::ViewComponent::Icon.new(
  name: "user",
  variant: "solid",
  class: ["w-8", "h-8", "text-gray-700"]
) %>

<!-- With data attributes -->
<%= render Heroicons::ViewComponent::Icon.new(
  name: "heart",
  class: "w-5 h-5",
  data: { controller: "icon", action: "click->favorite#toggle" }
) %>

<!-- With aria attributes -->
<%= render Heroicons::ViewComponent::Icon.new(
  name: "search",
  class: "w-6 h-6",
  id: "search-icon",
  aria: { label: "Search" }
) %>
```

### In ViewComponents

You can use Heroicons in your own ViewComponents:

```ruby
class UserProfileComponent < ViewComponent::Base
  def initialize(user:)
    @user = user
  end

  private

  attr_reader :user
end
```

```erb
<!-- user_profile_component.html.erb -->
<div class="profile">
  <%= render Heroicons::ViewComponent::Icon.new(
    name: "user-circle",
    variant: "solid",
    class: "w-10 h-10 text-blue-500"
  ) %>
  <span><%= user.name %></span>
</div>
```

### In Rails Helpers

You can also use it in helpers:

```ruby
module ApplicationHelper
  def icon(name, variant: "outline", **options)
    render Heroicons::ViewComponent::Icon.new(
      name: name,
      variant: variant,
      **options
    )
  end
end
```

Then use it in your views:

```erb
<%= icon("home", variant: "solid", class: "w-6 h-6") %>
```

## Icon Names

Icon names should match the Heroicons naming convention (kebab-case). For example:

- `academic-cap`
- `adjustments-horizontal`
- `arrow-down`
- `user-circle`
- `arrow-down-circle`

Browse all available icons at [heroicons.com](https://heroicons.com/).

## API Reference

### `Heroicons::ViewComponent::Icon.new(name:, variant: "outline", size: "24", **html_options)`

Creates a new Icon component instance.

#### Parameters

- `name` (required): The icon name in kebab-case (e.g., `"arrow-down-circle"`)
- `variant` (optional): Icon variant, either `"outline"` or `"solid"` (default: `"outline"`)
- `size` (optional): Icon size, either `"16"`, `"20"`, or `"24"` (default: `"24"`)
- `**html_options` (optional): Additional HTML attributes to merge into the SVG element

#### Examples

```ruby
# Basic usage
icon = Heroicons::ViewComponent::Icon.new(name: "home")

# With custom classes
icon = Heroicons::ViewComponent::Icon.new(
  name: "user",
  variant: "solid",
  class: "w-6 h-6 text-blue-500"
)

# With multiple attributes
icon = Heroicons::ViewComponent::Icon.new(
  name: "search",
  id: "search-icon",
  class: "w-5 h-5",
  data: { controller: "search" },
  aria: { label: "Search" }
)
```

## Performance

The gem uses lazy-loading with intelligent caching:

- Icons are loaded from disk only when first requested
- Subsequent requests use cached SVG content
- Thread-safe caching ensures safe concurrent access
- Only icons that are actually used are cached in memory

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Running Tests

```bash
# Run all tests
bundle exec rake test

# Run tests directly
ruby -Itest test/heroicons/view_component/icon_test.rb
```

### Code Quality

```bash
# Run RuboCop
bundle exec rubocop
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/kpost/heroicons-view-components](https://github.com/kpost/heroicons-view-components).

1. Fork the repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Make your changes
4. Add tests for your changes
5. Ensure all tests pass (`bundle exec rake test`)
6. Ensure RuboCop passes (`bundle exec rubocop`)
7. Commit your changes (`git commit -am 'Add some feature'`)
8. Push to the branch (`git push origin my-new-feature`)
9. Create a new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits

- [Heroicons](https://heroicons.com/) - Beautiful hand-crafted SVG icons by the makers of Tailwind CSS
- [ViewComponent](https://viewcomponent.org/) - A framework for building view components in Rails

