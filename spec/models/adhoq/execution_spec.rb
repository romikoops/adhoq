module Adhoq
  RSpec.describe Execution, type: :model do
    before do
      storage = Adhoq::Storage::OnTheFly.new
      allow(Adhoq).to receive(:current_storage) { storage }
    end

    let(:execution) do
      query = create(:adhoq_query, query: 'SELECT name, description FROM adhoq_queries')
      query.execute!('xlsx')
    end

    # check delegated attributes
    specify { expect(execution.supported_formats).to eq %w{csv json xlsx} }
    specify { expect(execution.query_slug).to eq execution.query.slug }

    specify 'file name starts with a slug' do
      expect(execution.name.starts_with?(execution.query_slug)).to eq true 
    end

    specify { expect(execution.report).to be_on_the_fly }

    specify 'can get report only on execution' do
      expect(execution.report.data).to have_values_in_xlsx_sheet([
                                                                   %w[name description],
                                                                   ['A query', 'Simple simple SELECT']
                                                                 ])

      # Accessable only once
      expect(execution.report.data).to be_nil
    end

    describe '#generate_report!' do
      subject { -> { execution.generate_report! } }

      let(:execution) { Execution.new(query: query, raw_sql: query.query, report_format: 'csv') }

      context 'when execute query successfully' do
        let(:query) { create(:adhoq_query, query: 'SELECT name, description FROM adhoq_queries') }

        it { is_expected.to change { execution.status.to_s }.to('success') }
      end

      context 'when execute query failed' do
        let(:query) { create(:adhoq_query, query: 'INVALID SQL') }

        it { is_expected.to change { execution.status.to_s }.to('failure') }
      end
    end
  end
end
