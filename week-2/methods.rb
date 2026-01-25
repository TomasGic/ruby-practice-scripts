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
  task_num = gets.chomp.to_i
  tasks.delete_at(task_num - 1)
  puts "Task has been successfully deleted!"
end


def view_menu()
  puts "Type in one of the following commands and press Enter: 
          1. to display all tasks type 'dis-all'
          2. to add a new task type 'add'
          3. to delete an existing task type 'del'
          4. to change the task's name type 'edit'
          5. to display only completed tasks type 'dis-comp'
          6. to exit the program type 'exit'"
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
 

