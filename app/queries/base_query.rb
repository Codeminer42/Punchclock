BaseQuery = Struct.new(:model) do

  protected

  def t
    model.arel_table
  end
end
