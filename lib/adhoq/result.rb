module Adhoq
  class Result
    attr_reader :header, :rows

    def initialize(header, rows = [])
      @header = header
      @rows   = rows
    end

    def <<(row)
      rows << row
    end

    def ==(other)
      header == other.header && rows == other.rows
    end
  end
end
