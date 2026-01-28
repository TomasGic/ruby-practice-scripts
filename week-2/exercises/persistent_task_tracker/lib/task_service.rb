def add_task(tasks)
  puts "Type the name of the task you would like to add."
  task_name = gets.chomp
  task = {
    title: task_name,
    done: false
  }
  tasks.push(task)
  puts "Task has been successfully added!"
end


def display_tasks(tasks)
  if tasks.empty?
    puts "You don't have any tasks, type 'add' to add a task."
  else 
    tasks.each_with_index do |task, index|
      status = task[:done] == true ? "completed" : "not completed"
      puts "#{index+1}: #{task[:title]} - #{status}"
    end
  end
end


def delete_task(tasks)
  puts "Type the number of the task you would like to delete."
  task_index = gets.chomp.to_i - 1
  deleted_task = tasks[task_index]
  tasks.delete_at(task_index)
  puts "Task #{deleted_task[:title]}has been successfully deleted!"
end


def view_menu()
  puts "Type in one of the following commands and press Enter: 
          1. to display all tasks type 'dis-all'
          2. to add a new task type 'add'
          3. to delete an existing task type 'del'
          4. to change the task's name type 'edit'
          5. to mark a task as complete type 'mark-comp'
          6. to display only completed tasks type 'dis-comp'
          7. to delete all tasks type 'del-all'
          8. to search for a specific task type 'search'
          9. to sort the tasks alphabetically type 'sort-a'
          10. to sort the tasks by their status type 'sort-s'
          11. to exit the program type 'exit'"
end


def edit_task_name(tasks)
  puts "Type the number of the task you want to change the title of: "
  task_num = gets.chomp.to_i
  task_to_edit = tasks[task_num - 1] 
  puts "Type the new name of the task:"
  new_title = gets.chomp
  task_to_edit[:title] = new_title
  puts "Task name has been changed successfully!"
end


def display_completed(tasks)
  completed_tasks = tasks.select { |task| task[:done] == true }
  if completed_tasks.empty? 
    puts "You don't have any completed tasks."
  else 
    completed_tasks.each_with_index do |task, index|
      puts "#{index+1}: #{task[:title]} - completed"
    end
  end
end


def mark_complete(tasks) 
  puts "Type the number of the task you want to mark as complete"
  task_num = gets.chomp.to_i
  task_completed = tasks[task_num - 1]
  task_completed[:done] = true
  puts "Task #{task_completed[:title]} has been marked as complete!"
end
 

def delete_all(tasks)
  puts "Are you sure you want to delete all tasks? Y/N"
  input = gets.chomp.downcase
  if input == "y"
    tasks.clear
    puts "All your tasks have been successfully deleted."
  elsif input == 'n'
    return
  else 
    puts "invalid input - please enter Y for yes or N for no."
  end
end


def search(tasks)
  puts "Type the name of the task you want to search: "
  keyword = gets.chomp.downcase
  search_results = tasks.select do |tasks|
    tasks[:title].downcase.include?(keyword)
  end
  return search_results
end


def sort_tasks_alphabetically(tasks)
  sorted_tasks = tasks.sort_by {|task| task[:title]}
  return sorted_tasks
end


def sort_tasks_by_status(tasks)
  sorted_tasks = tasks.sort_by {|task| task[:done] ? 0: 1}
  return sorted_tasks
end