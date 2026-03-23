require "terminal-table"

module RandomPeople
  module Formatters
    class TableFormatter
      def initialize(users)
        @users = users
      end

      def format
        return "no results found" if @users.empty?
        
        table = Terminal::Table.new do |t|
          t.headings = ["Full Name", "Age", "Country", "Group", "Email"]
          @users.each do |user|
            t << [user.full_name, user.age, user.country, user.group, user.email]
          end
        end
        table.to_s
      end
    end
  end
end