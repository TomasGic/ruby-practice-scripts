require_relative "lib/task_service"
require_relative "lib/task_store"

user_inputs = []
tasks = load_tasks

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
    save_tasks(tasks)
    
  when "del"
    display_tasks(tasks)
    delete_task(tasks)
    save_tasks(tasks)

  when "edit"
    display_tasks(tasks)
    edit_task_name(tasks)
    save_tasks(tasks)
  
  when "dis-comp"
    display_completed(tasks)
  
  when "mark-comp"
    display_tasks(tasks)
    mark_complete(tasks)
    save_tasks(tasks)
  
  when "del-all"
    delete_all(tasks)
    save_tasks(tasks)
  
  when "search"
    results = search(tasks)
    if results.empty?
      puts "No tasks with the given name have been found"
    else display_tasks(results)
    end
  
  when "sort-a"
    tasks = sort_tasks_alphabetically(tasks)
    display_tasks(tasks)
    save_tasks(tasks)

  when "sort-s"
    tasks = sort_tasks_by_status(tasks)
    display_tasks(tasks)
    save_tasks(tasks)
  
  when "exit"
    break
  
  else 
    puts "Invalid command"
    view_menu()
  end
end