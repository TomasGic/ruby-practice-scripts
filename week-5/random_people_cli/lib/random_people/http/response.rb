module RandomPeople
  module HTTP
    Response = Struct.new(:status, :body, keyword_init: true) do
      def success?
        status.to_i >= 200 && status.to_i < 300
      end
    end
  end
end