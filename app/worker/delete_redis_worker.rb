class DeleteRedisWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'other'

  def perform(name)
    $redis.flushdb
  end

end
