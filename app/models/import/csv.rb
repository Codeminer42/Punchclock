module Import
  class CSV
    def initialize @input_file
      @lines = ::CSV.read(@input_file)
    end
  end
end
