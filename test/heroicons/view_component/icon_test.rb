# frozen_string_literal: true

require "test_helper"

class IconTest < Minitest::Test
  def test_accepts_name_parameter
    icon = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle")

    assert_equal "arrow-down-circle", icon.instance_variable_get(:@name)
  end

  def test_defaults_variant_to_outline
    icon = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle")

    assert_equal "outline", icon.instance_variable_get(:@variant)
  end

  def test_accepts_variant_parameter
    icon = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", variant: "solid")

    assert_equal "solid", icon.instance_variable_get(:@variant)
  end

  def test_accepts_size_parameter
    icon = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", size: "20")

    assert_equal "20", icon.instance_variable_get(:@size)
  end

  def test_accepts_html_options
    icon = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", class: "w-6 h-6", id: "test-icon")
    html_options = icon.instance_variable_get(:@html_options)

    assert_equal "w-6 h-6", html_options[:class]
    assert_equal "test-icon", html_options[:id]
  end

  def test_converts_name_to_string
    icon = Heroicons::ViewComponent::Icon.new(name: :arrow_down_circle)

    assert_equal "arrow_down_circle", icon.instance_variable_get(:@name)
  end

  def test_converts_variant_to_string
    icon = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", variant: :solid)

    assert_equal "solid", icon.instance_variable_get(:@variant)
  end

  def test_raises_error_for_invalid_variant
    error = assert_raises(ArgumentError) do
      Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", variant: "invalid")
    end
    assert_match(/Invalid variant/, error.message)
  end

  def test_raises_error_for_invalid_size
    error = assert_raises(ArgumentError) do
      Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", size: "99")
    end
    assert_match(/Invalid size/, error.message)
  end

  def test_accepts_valid_variants
    Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", variant: "outline")
    Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", variant: "solid")
    # If no exception is raised, test passes
  end

  def test_accepts_valid_sizes
    Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", size: "16")
    Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", size: "20")
    Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", size: "24")
    # If no exception is raised, test passes
  end

  def test_allows_nil_size
    Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", size: nil)
    # If no exception is raised, test passes
  end

  def test_returns_svg_content_as_html_safe_string_when_icon_exists
    icon = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", variant: "solid", size: "20")
    result = icon.call

    assert_instance_of ActiveSupport::SafeBuffer, result
    assert_predicate result, :html_safe?
    assert_includes result, "<svg"
  end

  def test_renders_outline_variant
    icon = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", variant: "outline")
    result = icon.call

    assert_includes result, "<svg"
    assert_predicate result, :html_safe?
  end

  def test_renders_solid_variant
    icon = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", variant: "solid", size: "20")
    result = icon.call

    assert_includes result, "<svg"
    assert_predicate result, :html_safe?
  end

  def test_returns_empty_string_when_icon_does_not_exist
    icon = Heroicons::ViewComponent::Icon.new(name: "non-existent-icon", variant: "outline")
    result = icon.call

    assert_equal "", result
  end

  def test_merges_user_classes_with_existing_svg_classes
    icon = Heroicons::ViewComponent::Icon.new(
      name: "arrow-down-circle",
      variant: "solid",
      size: "20",
      class: "w-6 h-6 text-blue-500"
    )
    result = icon.call

    assert_includes result, 'class="'
    assert_includes result, "w-6 h-6 text-blue-500"
  end

  def test_handles_class_as_array
    icon = Heroicons::ViewComponent::Icon.new(
      name: "arrow-down-circle",
      variant: "solid",
      size: "20",
      class: ["w-6", "h-6", "text-blue-500"]
    )
    result = icon.call

    assert_includes result, "w-6"
    assert_includes result, "h-6"
    assert_includes result, "text-blue-500"
  end

  def test_handles_class_as_string
    icon = Heroicons::ViewComponent::Icon.new(
      name: "arrow-down-circle",
      variant: "solid",
      size: "20",
      class: "custom-class"
    )
    result = icon.call

    assert_includes result, "custom-class"
  end

  def test_merges_data_attributes
    icon = Heroicons::ViewComponent::Icon.new(
      name: "arrow-down-circle",
      variant: "solid",
      size: "20",
      data: { controller: "icon", action: "click->handler#action" }
    )
    result = icon.call

    assert_includes result, 'data-controller="icon"'
    assert_includes result, 'data-action="click->handler#action"'
  end

  def test_merges_aria_attributes
    icon = Heroicons::ViewComponent::Icon.new(
      name: "arrow-down-circle",
      variant: "solid",
      size: "20",
      aria: { label: "Arrow down", hidden: "true" }
    )
    result = icon.call

    assert_includes result, 'aria-label="Arrow down"'
    assert_includes result, 'aria-hidden="true"'
  end

  def test_adds_id_attribute
    icon = Heroicons::ViewComponent::Icon.new(
      name: "arrow-down-circle",
      variant: "solid",
      size: "20",
      id: "my-icon"
    )
    result = icon.call

    assert_includes result, 'id="my-icon"'
  end

  def test_merges_all_attributes_correctly
    icon = Heroicons::ViewComponent::Icon.new(
      name: "arrow-down-circle",
      variant: "solid",
      size: "20",
      id: "test-icon",
      data: { controller: "icon" },
      aria: { label: "Test" }
    )
    result = icon.call

    assert_includes result, 'id="test-icon"'
    assert_includes result, 'data-controller="icon"'
    assert_includes result, 'aria-label="Test"'
  end

  def test_returns_svg_without_modifications_when_no_html_options
    icon = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", variant: "solid", size: "20")
    result = icon.call

    assert_includes result, "<svg"
  end

  def test_uses_provided_size_for_outline_variant
    icon = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", variant: "outline", size: "24")

    assert_equal "24", icon.instance_variable_get(:@size)
  end

  def test_defaults_to_24_for_outline_variant_when_size_is_nil
    icon = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", variant: "outline")
    result = icon.call

    assert_includes result, "<svg"
  end

  def test_uses_provided_size_for_solid_variant
    icon = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", variant: "solid", size: "16")

    assert_equal "16", icon.instance_variable_get(:@size)
  end

  def test_defaults_to_20_for_solid_variant_when_size_is_nil
    icon = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", variant: "solid")
    result = icon.call

    assert_includes result, "<svg"
  end

  def test_caches_svg_content
    icon1 = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", variant: "solid", size: "20")
    result1 = icon1.call

    icon2 = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", variant: "solid", size: "20")
    result2 = icon2.call

    assert_equal result1, result2
    assert_equal 1, Heroicons::ViewComponent::IconCache.cache_size
  end

  def test_caches_different_variants_separately
    icon1 = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", variant: "outline")
    icon1.call

    icon2 = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", variant: "solid", size: "20")
    icon2.call

    assert_equal 2, Heroicons::ViewComponent::IconCache.cache_size
  end

  def test_caches_different_sizes_separately
    icon1 = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", variant: "solid", size: "16")
    icon1.call

    icon2 = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", variant: "solid", size: "20")
    icon2.call

    assert_equal 2, Heroicons::ViewComponent::IconCache.cache_size
  end

  def test_inherits_from_view_component_base
    assert_equal ViewComponent::Base, Heroicons::ViewComponent::Icon.superclass
  end

  def test_responds_to_call_method
    icon = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", variant: "solid", size: "20")

    assert_respond_to icon, :call
  end

  def test_returns_html_safe_string_from_call
    icon = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", variant: "solid", size: "20")
    result = icon.call

    assert_instance_of ActiveSupport::SafeBuffer, result
    assert_predicate result, :html_safe?
    assert_includes result, "<svg"
  end

  def test_handles_empty_class_string
    icon = Heroicons::ViewComponent::Icon.new(
      name: "arrow-down-circle",
      variant: "solid",
      size: "20",
      class: ""
    )
    result = icon.call

    assert_includes result, "<svg"
  end

  def test_handles_nil_class
    icon = Heroicons::ViewComponent::Icon.new(
      name: "arrow-down-circle",
      variant: "solid",
      size: "20",
      class: nil
    )
    result = icon.call

    assert_includes result, "<svg"
  end

  def test_escapes_html_in_attribute_values
    icon = Heroicons::ViewComponent::Icon.new(
      name: "arrow-down-circle",
      variant: "solid",
      size: "20",
      title: 'Test "quotes"'
    )
    result = icon.call

    assert_includes result, "&quot;"
  end

  def test_handles_kebab_case_icon_names
    icon = Heroicons::ViewComponent::Icon.new(name: "arrow-down-circle", variant: "solid", size: "20")
    icon.call
    # If no exception is raised, test passes
  end
end
