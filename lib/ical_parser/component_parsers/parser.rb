module IcalParser
  module Parser

    protected

    def parse_params(params)
      params_array = params.split(";").map do |param|
        key, value = param.split("=")
      end
      params_array.to_h
    end
  end
end
