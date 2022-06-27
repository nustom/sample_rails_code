# used for seding emails when a task is assigned
# a task is completed
# or a comment is added to the task
class AdminTasksMailer < ApplicationMailer
  def new_task(task, cc)
    @task = task
    mail(
      to: task.assigned_to.email,
      cc: cc,
      subject: 'New task assigned to you'
    )
  end

  def task_completed(task)
    @task = task
    mail(
      to: task.assigned_to.email,
      subject: 'Task completed'
    )
  end

  def task_new_comment(task, comment, to_user)
    @to_user = to_user
    @task = task
    @comment = comment
    mail(
      to: to_user.email,
      subject: 'A new comment added to your task'
    )
  end
end
