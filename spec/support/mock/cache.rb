module Mock
  class Cache
    def read(_key)
      @data
    end

    def write(_key, data, expires_in:)
      @data = data
    end
  end
end
