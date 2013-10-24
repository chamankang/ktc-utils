module KTC
  class Helpers
    class << self

      # takes as input an array of hashes and outputs simple array that only has necessary fields
      # @param Array of hashs that has process list
      # @return Array that only contains values whose keys are matched
      def select_and_strip_keys input_array, key
        input_array.each do |hash_element|
          hash_element.keep_if { |k, v| k == key }
        end

        output_array = input_array.map { |kv_pair| kv_pair.values[0] }
      end
    end
  end
end
