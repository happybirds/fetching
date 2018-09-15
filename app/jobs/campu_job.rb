class CampuJob

  def perform
    CampuWorker.perform_async('CampuJob')
  end

end
