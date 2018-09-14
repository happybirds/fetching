class ClearCronlogJob
  def perform
    CronoJob.all.update(log: '')
    sleep(5)
  end
end
