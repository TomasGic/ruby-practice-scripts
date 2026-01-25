def add_task(name, tasks)
  task = {
    title: name,
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


def delete_task(tasks, index)
  tasks.delete_at(index - 1)
    puts "Task has been successfully deleted!"
end


def view_menu()
  puts "Type in one of the following commands and press Enter: 
          1. to display all tasks type 'dis-all'
          2. to add a new task type 'add'
          3. to delete an existing task type 'del'
          4. to exit the program type 'exit'"
end


