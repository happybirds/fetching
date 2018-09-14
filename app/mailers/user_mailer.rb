class UserMailer < ApplicationMailer

  default from: ENV['MAIL_FROM']

  def sample_email(courses,subject)
    @courses = courses
    @subject = subject

    mail(to: ENV['MAIL_TO'], subject: "#{@subject}-#{Date.today}")
  end
end
