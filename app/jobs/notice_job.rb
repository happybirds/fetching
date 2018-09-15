class NoticeJob

  def perform
    NoticeWorker.perform_async('NoticeJob')
  end

end
