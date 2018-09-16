class CampuWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'campu'

  def perform(name)
  


  end

end
