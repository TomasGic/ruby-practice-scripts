user_inputs = []
tasks = []

while true
  if user_inputs.empty?
    puts "To start the program type in one of the following commands and press Enter: 
          1. to display all tasks type 'dis-all'
          2. to add a new task type 'add'
          3. to delete an existing task type 'del'
          4. to exit the program type 'exit'"
  else 
    puts "Enter a command: "
  end

  user_input = gets.chomp
  user_inputs.push(user_input)
  
  case user_input
  when "dis-all"
    if tasks.empty?
      puts "No tasks yet, type 'add' to add your first task"
    else 
      tasks.each_with_index do |task, index|
        puts "#{index+1}: #{task}"
      end
    end
  when "add"
    puts "Type the name of the task you would like to add"
    task_to_add = gets.chomp
    tasks.push(task_to_add)
    puts "Task has been successfully added"
  when "del"
    tasks.each_with_index do |task, index|
        puts "#{index+1}: #{task}"
    end
    puts "Type the number of the task you would like to delete"
    task_index = gets.chomp.to_i
    tasks.delete_at(task_index - 1)
    puts "Tasks has been successfully deleted"
  when "exit"
    break
    
  end
end
