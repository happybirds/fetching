class UserMailer < ApplicationMailer

  default from: ENV['MAIL_FROM']

  def sample_email(courses,subject)
    @courses = courses
    @subject = subject

    mail(to: ENV['MAIL_TO'], subject: "#{@subject}-#{Date.today}")
  end

   def campu_email(campus,subject)
    @campus = campus
    @subject = subject

    mail(to: ENV['MAIL_TO'], subject: "#{@subject}-#{Date.today}")
  end
end
