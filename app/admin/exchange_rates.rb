ActiveAdmin.register ExchangeRate do
  config.sort_order = "year_desc"
  permit_params :year, :currency, :rate

  index do
    column :year
    column :currency, sortable: false
    column :rate, sortable: false
    actions
  end

  filter :year_equals
  filter :currency, as: :select, collection: ExchangeRate.currency.options
end
