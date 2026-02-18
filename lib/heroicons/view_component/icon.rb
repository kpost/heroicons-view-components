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
          raw_svg.empty? ? "" : merge_html_attributes(raw_svg)
        end
      end

      def merge_html_attributes(svg_string)
        # Fast path: no HTML options to merge
        return svg_string if html_options.empty?

        # Find the opening <svg> tag
        svg_tag_match = svg_string.match(/<svg([^>]*)>/)
        return svg_string unless svg_tag_match

        # Parse existing attributes from SVG string into a hash
        existing_attrs_hash = parse_svg_attributes(svg_tag_match[1])

        # Merge user-provided options with existing attributes
        merged_attrs = merge_attributes(existing_attrs_hash, html_options)

        # Reconstruct SVG tag from merged attributes hash
        new_svg_tag = build_svg_tag(merged_attrs)
        svg_string.sub(/<svg[^>]*>/, new_svg_tag)
      end

      def parse_svg_attributes(attrs_string)
        return {} if attrs_string.nil? || attrs_string.strip.empty?

        attrs_hash = {}
        # Match attribute="value" or attribute='value' patterns
        # Handles attributes with colons (like xmlns), hyphens, and underscores
        attrs_string.scan(/([\w\-:]+)=["']([^"']*)["']/) do |key, value|
          attrs_hash[key] = value
        end
        attrs_hash
      end

      def merge_attributes(existing, new_options)
        merged = existing.dup

        new_options.each do |key, value|
          attr_name = key.to_s.tr("_", "-")

          if value.is_a?(Hash)
            # Handle nested attributes like data: { controller: "icon" }
            value.each do |nested_key, nested_value|
              nested_attr = nested_key.to_s.tr("_", "-")
              merged["#{attr_name}-#{nested_attr}"] = nested_value.to_s
            end
          else
            # Override existing attribute with new value
            merged[attr_name] = normalize_attribute(value)
          end
        end

        merged
      end

      def build_svg_tag(attrs_hash)
        attrs_string = attrs_hash.map do |key, value|
          %(#{key}="#{escape_html(value)}")
        end.join(" ")

        "<svg #{attrs_string}>"
      end

      def normalize_attribute(attr_value)
        attr_value = attr_value.join(" ") if attr_value.is_a?(Array)
        attr_value.to_s
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
