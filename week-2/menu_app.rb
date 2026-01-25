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
    add_task(tasks)
    
  when "del"
    display_tasks(tasks)
    delete_task(tasks)

  when "edit"
    edit_task_name(tasks)
  
  when "exit"
    break
  
  else 
    puts "Invalid command"
    view_menu()
  end
end