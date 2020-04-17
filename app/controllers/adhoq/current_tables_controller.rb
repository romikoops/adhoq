module Adhoq
  class CurrentTablesController < Adhoq::ApplicationController
    before_action :eager_load_models

    def index
      hidden_model_names = Array(Adhoq.config.hidden_model_names)
      hidden_model_names << 'SchemaMigration' # service
      hidden_model_names << 'ApplicationRecord' # service
      hidden_model_names << 'ArInternalMetadatum'
      hidden_model_names << 'AdhoqQuery'
      hidden_model_names << 'AdhoqExecution'
      hidden_model_names << 'AdhoqReport'
      hidden_model_names << 'PspPayment' # old table?
      hidden_model_names << 'CountriesPaymentMethod' # hbtm
      hidden_model_names << 'SutorMessage'
      hidden_model_names << 'SutorReconciliation'
      hidden_model_names << 'SutorAccount'
      hidden_model_names << 'PartnerOrdersSutorReconciliation'
      hidden_model_names << 'BankTransactionsOrder' 
      hidden_model_names << 'Version' # papertrail
      hidden_model_names << 'DiscountsOrder' # hbtm
      hidden_model_names << 'ActiveStorageBlob'
      hidden_model_names << 'ActiveStorageAttachment'

      @ar_classes = ActiveRecord::Base.connection.tables.map { |model| model.capitalize.singularize.camelize }.
        reject { |model_name| hidden_model_names.include?(model_name) }.
        map { |model_name| model_name.constantize }.
        sort_by(&:name)

      render layout: false
    end

    private

    def eager_load_models
      return unless Rails.env.development?
      [Rails.application, Adhoq::Engine].each(&:eager_load!)
    end
  end
end
