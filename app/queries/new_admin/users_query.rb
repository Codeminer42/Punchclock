module NewAdmin
  class UsersQuery
    def initialize(filters)
      self.filters = filters
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      User.order(name: :asc)
          .by_name_like(filters[:name])
          .by_email_like(filters[:email])
          .by_backend_level(filters[:backend_level])
          .by_frontend_level(filters[:frontend_level])
          .by_office(filters[:office_id])
          .by_contract_type(filters[:contract_type])
          .by_active(filters[:active])
    end

    private

    attr_accessor :filters
  end
end
