class AssessmentDeleteService < ContentDeleteService
  def delete_item
    item.update(active: false)
  end
end
