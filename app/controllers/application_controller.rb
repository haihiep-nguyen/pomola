class ApplicationController < ActionController::Base
  def parse_command(command)
    command_as_array = command.split(' ')
    size_command = command_as_array.size
    first_word = command_as_array.try(:first)
    if size_command > 1 && first_word.present?
      command_result(first_word.try(:downcase), command_as_array)
    else
      false
    end
  end

  def command_result(command_action, command_as_array)
    if command_action == 't' || command_action == 'task'
      if command_as_array.second.include?('@')
        return {action: 'create_task',
                category: command_as_array.second,
                task_description: command_as_array[2..-1].join(' ')}
      else
        return {action: 'create_task',
                category: nil,
                task_description: command_as_array[1..-1].join(' ')}
      end
    elsif command_action == 'b' || command_action == 'begin'
      return {action: 'begin_task', tasks: command_as_array.drop(1)}
    elsif command_action == 'st' || command_action == 'stop'
      return {action: 'stop_task', tasks: command_as_array.drop(1)}
    elsif command_action == 'e' || command_action == 'edit'
      return {action: 'edit_task',
              task: command_as_array[1],
              task_description: command_as_array[2..-1].join(' ')}
    elsif command_action == 'd' || command_action == 'delete'
      return {action: 'delete_task', tasks: command_as_array.drop(1)}
    elsif command_action == 'today'
      return {action: 'today_task'}
    else
      return {action: 'create_task', category: nil, task_description: command_as_array.join(' ')}
    end
  end
end
