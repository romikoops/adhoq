module Adhoq
  class HiddenTable < ActiveRecord::Base
    validates :name, presence: true
  end
end