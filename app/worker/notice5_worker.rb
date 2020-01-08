class Notice5Worker
  include Sidekiq::Worker
  sidekiq_options queue: 'notice5'
  def perform(uri,count_min,count_max)
    Section.get_section(uri,count_min,count_max)
  end


end
