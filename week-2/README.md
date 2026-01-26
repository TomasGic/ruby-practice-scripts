This is a simple CLI app written in Ruby. It lets users add, delete, edit and display tasks. 

The app uses hashes inside an array as the main data structure model. Tasks is an array object which stores each individual task as a hash containing two key-value pairs - task's name and task's status.

The app starts with an options menu which explains all possible commands that the user can enter. 
Each option's logic is implemented using one helper method. The methods are the following: 

1. view_menu() - displays all possible options for the user.

2. display_tasks(tasks) - displays all tasks from the array, one on each line.

3. add_task(tasks) - adds a new task to the array of tasks using the push method and setting the default status as false. 

4. delete_task(tasks) - lets user delete a specific task. User has to provide the task number which will be used as an index to find a given task and delete it fromm the array using the delete_at method.

5. delete_all(tasks) - lets user delete all tasks with confirmation. When user types 'y' the app clears all tasks from the array using the clear method. The clear method mutates the original array. 

6. edit_task_name(tasks) - lets user change the task name. User chooses the task they want to change by providing the task number and then they are prompted to enter the new name of the task. 

7. mark_complete(tasks) - marks a specific task as complete. User chooses which task they want to mark as complete by providing the task's number. 

8. display_completed(tasks) - displays all tasks that have been marked as completed. This helper method primarily uses the select method to filter the array by its status. 


You can run the app in your terminal by typing 'ruby menu_app.rb' in your directory. 