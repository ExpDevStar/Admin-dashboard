module Trestle
  class Options < Hash
    def self.new(hash={})
      self[hash]
    end

    def merge(other)
      super(other) do |key, v1, v2|
        if v1.is_a?(Array)
          v1 + Array(v2)
        else
          v2
        end
      end
    end
  end
end
