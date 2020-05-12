module Adhoq
  RSpec.describe Executor::ConnectionWrapper, type: :model do
    describe '.select' do
      specify 'Do not reflect write access' do
        expect do
          Executor::ConnectionWrapper.new.select(<<-INSERT_SQL.strip_heredoc)
            INSERT INTO "adhoq_queries"
            ("description", "name", "query", "slug", "updated_at", "created_at")
            VALUES
            ("description", "name", "SELECT 1", "test-slug", "NOW", "NOW")
          INSERT_SQL
        end.not_to change(Adhoq::Query, :count)
      end
    end
  end
end
