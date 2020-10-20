module OmniAuth
  module Shopify
    class Scopes
      SCOPE_DELIMITER = ','

      def initialize(scope_names)
        if scope_names.is_a?(String)
          scope_names = scope_names.to_s.split(SCOPE_DELIMITER)
        end

        store_scopes(scope_names)
      end

      def include?(scopes)
        scopes.compressed_scopes <= expanded_scopes
      end

      def to_s
        to_a.join(SCOPE_DELIMITER)
      end

      def to_a
        compressed_scopes.to_a
      end

      def ==(other)
        other.class == self.class &&
          compressed_scopes == other.compressed_scopes
      end

      alias :eql? :==

      def hash
        compressed_scopes.hash
      end

      protected

      attr_reader :compressed_scopes, :expanded_scopes

      private

      def store_scopes(scope_names)
        scopes = scope_names.map(&:strip).reject(&:empty?).to_set
        implied_scopes = scopes.map { |scope| scope =~ /\A(unauthenticated_)?write_(.*)\z/ && "#{$1}read_#{$2}" }.compact

        @compressed_scopes = scopes - implied_scopes
        @expanded_scopes = scopes + implied_scopes
      end
    end
  end
end
