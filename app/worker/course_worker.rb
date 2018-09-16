class CourseWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'course'

  def perform(name)
  
 
  end

end
