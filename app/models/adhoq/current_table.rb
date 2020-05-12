module Adhoq
  class CurrentTable
    def self.all(*)
      connection = Adhoq.config.callablize(:database_connection).call
      (connection.tables - HiddenTable.pluck(:name)).sort.map do |table_name|
        new(table_name, connection)
      end
    end

    attr_reader :table_name, :connection

    def initialize(table_name, connection = Adhoq.config.callablize(:database_connection).call)
      @table_name = table_name
      @connection = connection
    end

    def rows_count
      connection.execute("SELECT COUNT(*) FROM #{table_name}")[0]['count']
    end

    def columns
      columns_hash.values.map { |el| column_data(el) }
    end

    private

    def columns_hash
      connection.schema_cache.columns_hash(table_name)
    end

    def primary_keys
      Array(connection.schema_cache.primary_keys(table_name))
    end

    def foreign_keys
      connection.schema_cache.foreign_keys(table_name)
    end

    def column_data(column)
      OpenStruct.new(
        primary_key?: primary_keys.include?(column.name),
        foreign_key?: column.name.match?(/_id\z/),
        name: column.name,
        type: column.type,
        null?: column.null,
        limit: column.limit,
        default: column.default
      )
    end
  end
end
