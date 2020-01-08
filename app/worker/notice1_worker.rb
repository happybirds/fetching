class Notice1Worker
  include Sidekiq::Worker
  sidekiq_options queue: 'notice1'
  def perform(uri,count_min,count_max)
    Section.get_section(uri,count_min,count_max)
  end


end
