class NoticeWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'notice'

  def perform(name)
  
  end

end
