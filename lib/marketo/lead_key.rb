module Rapleaf
  module Marketo
    # Encapsulates a key used to look up or describe a specific marketo lead.
    class LeadKey
      # - *key_type* the type of key to use see LeadKeyType
      # - *key_value* normally a string value for the given type
      # - *key_values* normally an array of string values for the given type
      def initialize(key_type, key_value)
        @key_type = key_type
        @key_value = key_value
      end

      # get the key type
      def key_type
        @key_type
      end

      # get the key value
      def key_value
        @key_value
      end

      # create a hash from this instance, for sending this object to marketo using savon
      def to_hash
        {
          :key_type => @key_type,
          :key_value => @key_value
        }
      end
    end

    class LeadKeys
      def initialize(key_type, *key_values)
        @key_type = key_type
        @key_values = key_values
      end

      # get the key type
      def key_type
        @key_type
      end

      # get the key values
      def key_values
        @key_values
      end

      # create a hash from this instance, for sending this object to marketo using savon
      def to_hash
        {
          key_type: @key_type,
          key_values: {string_item: @key_values}
        }
      end
    end

  end
end
