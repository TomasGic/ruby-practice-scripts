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
    display_tasks(tasks)
    edit_task_name(tasks)
  
  when "dis-comp"
    display_completed(tasks)
  
  when "mark-comp"
    display_tasks(tasks)
    mark_complete(tasks)
  
  when "exit"
    break
  
  else 
    puts "Invalid command"
    view_menu()
  end
end