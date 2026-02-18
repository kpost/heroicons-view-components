# frozen_string_literal: true

module Heroicons
  module ViewComponent
    class IconCache
      @cache = {}
      @mutex = Mutex.new

      class << self
        def get(size:, variant:, name:)
          key = cache_key(size: size, variant: variant, name: name)

          # Check cache first (fast path)
          cached = @mutex.synchronize { @cache[key] }
          return cached if cached

          # Load from file and cache (slow path)
          @mutex.synchronize do
            # Double-check after acquiring lock (in case another thread loaded it)
            return @cache[key] if @cache[key]

            svg_content = load_from_file(size: size, variant: variant, name: name)
            @cache[key] = svg_content.freeze if svg_content
            svg_content
          end
        end

        def clear
          @mutex.synchronize { @cache.clear }
        end

        def cache_size
          @mutex.synchronize { @cache.size }
        end

        private

        def cache_key(size:, variant:, name:)
          "#{size}/#{variant}/#{name}"
        end

        def load_from_file(size:, variant:, name:)
          path = svg_path(size: size, variant: variant, name: name)
          return unless File.exist?(path)

          content = File.read(path)
          # Remove XML declaration and clean up whitespace
          content.gsub(/<\?xml[^>]*\?>/, "").strip
        end

        def svg_path(size:, variant:, name:)
          File.join(__dir__, "..", "..", "..", "vendor", "heroicons", size.to_s, variant, "#{name}.svg")
        end
      end
    end
  end
end
