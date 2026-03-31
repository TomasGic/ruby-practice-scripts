require "terminal-table"

module RandomPeople
  module Formatters
    class TableFormatter
      

      def format(users)
        table = Terminal::Table.new do |t|
          t.headings = ["Full Name", "Age", "Country", "Group", "Email"]
          users.each do |user|
            t << [user.full_name, user.age, user.country, user.group, user.email]
          end
        end
        table.to_s
      end
    end
  end
end