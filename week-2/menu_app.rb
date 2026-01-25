require_relative "methods"

user_inputs = []
tasks = []

while true
  if user_inputs.empty?
    view_menu()
  else 
    puts "Enter a command: "
  end

  user_input = gets.chomp
  user_inputs.push(user_input)
  
  case user_input
  when "dis-all"
    display_tasks(tasks)
  
  when "add"
    puts "Type the name of the task you would like to add."
    task_to_add = gets.chomp
    add_task(task_to_add, tasks)
    
  when "del"
    display_tasks(tasks)
    puts "Type the number of the task you would like to delete."
    task_number = gets.chomp.to_i
    delete_task(tasks, task_number)
  
  when "exit"
    break
  
  else 
    puts "Invalid command"
    view_menu()
  end
end