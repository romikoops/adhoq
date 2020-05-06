module Adhoq
  class QueriesController < Adhoq::ApplicationController
    def index
      @queries = Adhoq::Query.recent_first
    end

    def show
      @query = Adhoq::Query.find(params[:id])
    end

    def new
      @query = Adhoq::Query.new
    end

    def create
      @query = Adhoq::Query.new(query_attributes)
      @query.save

      render action: :create
    end

    def edit
      @query = Adhoq::Query.find(params[:id])
    end

    def update
      @query = Adhoq::Query.find(params[:id])
      @query.update(query_attributes)
      render action: :update
    end

    def destroy
      Adhoq::Query.find(params[:id]).destroy!
      redirect_to action: :index
    end

    private

    def query_attributes
      params.require(:query).permit(:slug, :name, :description, :query)
    end
  end
end
