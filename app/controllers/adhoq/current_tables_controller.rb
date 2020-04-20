module Adhoq
  class CurrentTablesController < Adhoq::ApplicationController
    def index
      @current_tables = Adhoq::CurrentTable.all(exclude_tables: Adhoq::HiddenTable.pluck(:name))
      render layout: false
    end
  end
end
