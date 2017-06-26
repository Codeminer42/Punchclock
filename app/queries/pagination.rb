class Pagination
  def initialize(collection)
    @collection = collection
  end

  def with(params)
    @collection.page(params[:page]).per(params[:per])
  end

  def decorated(params)
    with(params).decorate
  end
end
