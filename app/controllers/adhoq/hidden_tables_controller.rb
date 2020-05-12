module Adhoq
  class HiddenTablesController < Adhoq::ApplicationController
    def index
      @hidden_tables = Adhoq::HiddenTable.all.order(:name)
    end

    def new
      @hidden_table = Adhoq::HiddenTable.new
    end

    def create
      @hidden_table = Adhoq::HiddenTable.new(hidden_table_attributes)
      if @hidden_table.save
        redirect_to action: :index
      else
        render :new
      end
    end

    def edit
      @hidden_table = Adhoq::HiddenTable.find(params[:id])
    end

    def update
      @hidden_table = Adhoq::HiddenTable.find(params[:id])
      if @hidden_table.update(hidden_table_attributes)
        redirect_to action: :index
      else
        render :edit
      end
    end

    def destroy
      Adhoq::HiddenTable.find(params[:id]).destroy!
      redirect_to action: :index
    end

    private

    def hidden_table_attributes
      params.require(:hidden_table).permit(:name)
    end
  end
end
