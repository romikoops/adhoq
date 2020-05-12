module Adhoq
  class ExplainsController < Adhoq::ApplicationController
    layout false

    def create
      @result = Adhoq::Executor.new(params[:query]).explain
    rescue ActiveRecord::StatementInvalid => @statement_invalid
      render 'statement_invalid', status: :unprocessable_entity
    end
  end
end
