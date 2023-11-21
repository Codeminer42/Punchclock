class DetailedMonthForecastSpreadsheet < DefaultSpreadsheet
  def body(allocation)
    [
      allocation[:user],
      allocation[:project],
      allocation[:hourly_rate],
      allocation[:start_date],
      allocation[:end_date],
      allocation[:worked_hours],
      allocation[:total_revenue]
    ]
  end

  def header
    [
      'Usuário',
      'Projeto/cliente',
      'Taxa horária',
      'Data de início',
      'Data de término',
      'Horas trabalhadas',
      'Faturamento total'
    ]
  end
end
