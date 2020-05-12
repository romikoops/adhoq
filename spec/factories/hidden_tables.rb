FactoryBot.define do
  factory :hidden_table, class: 'Adhoq::HiddenTable' do
    sequence(:name) { |n| "Secret_tables_#{n}_" }
  end
end
