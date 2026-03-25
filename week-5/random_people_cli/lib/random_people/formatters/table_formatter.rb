require "terminal-table"

module RandomPeople
  module Formatters
    class TableFormatter
      

      def format(users)
        return "no results found" if users.empty?
        
        table = Terminal::Table.new do |t|
          t.headings = ["First Name", "Last Name", "Age", "Country", "Group", "Email"]
          users.each do |user|
            t << [user.first_name, user.last_name, user.age, user.country, user.group, user.email]
          end
        end
        table.to_s
      end
    end
  end
end