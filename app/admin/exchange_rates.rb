ActiveAdmin.register ExchangeRate do
  config.sort_order = "year_desc"
  permit_params :month, :year, :currency, :rate

  index do
    column :month
    column :year
    column :currency, sortable: false
    column :rate, sortable: false
    actions
  end

  filter :month_equals
  filter :year_equals
  filter :currency, as: :select, collection: ExchangeRate.currency.options
end
