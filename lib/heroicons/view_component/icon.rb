# frozen_string_literal: true

require "view_component"
require_relative "icon_cache"

module Heroicons
  module ViewComponent
    class Icon < ::ViewComponent::Base
      VARIANTS = ["outline", "solid"].freeze
      SIZES = ["16", "20", "24"].freeze

      def initialize(name:, variant: "outline", size: "24", **html_options)
        super()
        @name = name.to_s
        @variant = variant.to_s
        @size = size&.to_s
        @html_options = html_options

        validate_variant!
        validate_size!
      end

      def call
        svg_content.html_safe
      end

      private

      attr_reader :name, :variant, :size, :html_options

      def svg_content
        @svg_content ||= begin
          raw_svg = IconCache.get(size: size, variant: variant, name: name) || ""

          if raw_svg.empty?
            ""
          else
            merge_html_attributes(raw_svg)
          end
        end
      end

      def merge_html_attributes(svg_string)
        # Fast path: no HTML options to merge
        return svg_string if html_options.empty?

        # Find the opening <svg> tag
        svg_tag_match = svg_string.match(/<svg([^>]*)>/)
        return svg_string unless svg_tag_match

        existing_attrs = svg_tag_match[1]
        new_attrs = []

        # Handle class attribute - merge with existing classes
        if html_options[:class]
          class_match = existing_attrs.match(/class=["']([^"']*)["']/)
          existing_classes = class_match ? class_match[1].strip : ""
          new_classes = normalize_class(html_options[:class])

          # Remove existing class attribute from string
          existing_attrs = existing_attrs.gsub(/class=["'][^"']*["']/, "").strip

          # Combine classes
          combined_classes = [existing_classes, new_classes].reject(&:empty?).join(" ")
          new_attrs << %(class="#{combined_classes}") unless combined_classes.empty?
        end

        # Add other HTML attributes
        html_options.except(:class).each do |key, value|
          attr_name = key.to_s.tr("_", "-")

          if value.is_a?(Hash)
            # Handle nested attributes like data: { controller: "icon" }
            value.each do |nested_key, nested_value|
              nested_attr = nested_key.to_s.tr("_", "-")
              new_attrs << %(#{attr_name}-#{nested_attr}="#{escape_html(nested_value)}")
            end
          else
            new_attrs << %(#{attr_name}="#{escape_html(value)}")
          end
        end

        # Reconstruct SVG tag
        all_attrs = [existing_attrs, *new_attrs].reject(&:empty?).join(" ")
        new_svg_tag = "<svg #{all_attrs}>"

        svg_string.sub(/<svg[^>]*>/, new_svg_tag)
      end

      def normalize_class(class_value)
        case class_value
        when Array
          class_value.join(" ")
        when String
          class_value
        else
          class_value.to_s
        end
      end

      def escape_html(value)
        value.to_s.gsub('"', "&quot;").gsub("'", "&#39;")
      end

      def validate_variant!
        return if VARIANTS.include?(@variant)

        raise ArgumentError, "Invalid variant: #{@variant}. Must be one of: #{VARIANTS.join(", ")}"
      end

      def validate_size!
        return if @size.nil? || SIZES.include?(@size)

        raise ArgumentError, "Invalid size: #{@size}. Must be one of: #{SIZES.join(", ")}"
      end
    end
  end
end
