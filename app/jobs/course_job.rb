class CourseJob

  def perform
    CourseWorker.perform_async('CourseJob')
  end

end
