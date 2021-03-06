class CourseJob

  def perform
        ms = ['Mon','Tue','Wed',"Thu",'Fri']
       if Time.now.strftime('%H').to_i > 7 && Time.now.strftime('%H').to_i < 23
      mechanize = Mechanize.new

      page = mechanize.post(ENV['U_URI'])

      form = page.forms.first

      form['username'] = ENV['U_USER']
      form['password'] = ENV['U_PWD']

      page = form.submit

      # dashboard = page.link_with(text: 'Dashboard').click

      cs3710_ay = []
      cs3620_ay =[]
      cs2920_ay =[]
      #cs2060_ay =[]
# page.search('.media-body').each do |e|
# p e.text.strip
#   if e.text.strip == '2020W CS-3710-1'
#     e.parent().parent().parent().attributes['href'].value
# binding.pry
#   end
# end

      cs3710 = page.link_with(text:"\n                \n                    \n                        \n                            \n                        \n                        2020W CS-3710-1\n                    \n                \n            ").click
      cs3710.search('.instancename').each do |i|
         cs3710_ay.push(i.text.strip)
      end

      cs3620 = page.link_with(text:"\n                \n                    \n                        \n                            \n                        \n                        2020W CS-3620-1\n                    \n                \n            ").click
      cs3620.search('.instancename').each do |i|
         cs3620_ay.push(i.text.strip)
      end

      cs2920 = page.link_with(text:"\n                \n                    \n                        \n                            \n                        \n                        2020W CS-2920-1\n                    \n                \n            ").click
      cs2920.search('.instancename').each do |i|
         cs2920_ay.push(i.text.strip)
      end

      # cs2060 = page.link_with(text:"\n                \n                    \n                        \n                            \n                        \n                        2019F CS-2060-1\n                    \n                \n            ").click
      # cs2060.search('.instancename').each do |i|
      #    cs2060_ay.push(i.text.strip)
      # end
      # cs = dashboard.link_with(text: '2019W Computer Science II (CS-1920-2)').click

      # cs.search('.instancename').each do |i|
      #   cs_ay.push(i.text.strip)
      # end

      # math = dashboard.link_with(text: '2019W Computer Org. and Architecture (CS-2520-1)').click

      # math.search('.instancename').each do |i|
      #   math_ay.push(i.text.strip)
      # end


      # phy = dashboard.link_with(text: '2018F Life in the Universe (PHYS-1510-1)').click

      # phy.search('.instancename').each do |i|
      #   phy_ay.push(i.text.strip)
      # end

      cs3710_ay.each do |b|
        if Course.find_by_title(b).nil?
          Course.create(title: b,catalog: 5,status: 2)
        end
      end
      cs3620_ay.each do |b|
        if Course.find_by_title(b).nil?
          Course.create(title: b,catalog: 6,status: 2)
        end
      end
       cs2920_ay.each do |b|
        if Course.find_by_title(b).nil?
          Course.create(title: b,catalog: 7,status: 2)
        end
      end
      #  cs2060_ay.each do |b|
      #   if Course.find_by_title(b).nil?
      #     Course.create(title: b,catalog: 8,status: 2)
      #   end
      # end



      if Course.where(catalog: 5,status: 2).count > 0
          @courses = Course.where(catalog: 5,status: 2)
          UserMailer.sample_email(@courses,'2020W CS-3710-1').deliver
          @courses.update(status: 1)
      end

      if Course.where(catalog: 6,status: 2).count > 0
          @courses = Course.where(catalog: 6,status: 2)
          UserMailer.sample_email(@courses,'2020W CS-3620-1').deliver
          @courses.update(status: 1)
      end

      if Course.where(catalog: 7,status: 2).count > 0
          @courses = Course.where(catalog: 7,status: 2)
          UserMailer.sample_email(@courses,'2020W CS-2920-1').deliver
          @courses.update(status: 1)
      end

      # if Course.where(catalog: 8,status: 2).count > 0
      #     @courses = Course.where(catalog: 8,status: 2)
      #     UserMailer.sample_email(@courses,'2019F CS-2060-1').deliver
      #     @courses.update(status: 1)
      # end
      # if Course.where(catalog: 2,status: 2).count > 0
      #     @courses = Course.where(catalog: 2,status: 2)
      #     UserMailer.sample_email(@courses,'Life in the Universe (PHYS-1510-1)').deliver
      #     @courses.update(status: 1)
      # end

      # if Course.where(catalog: 4,status: 2).count > 0
      #     @courses = Course.where(catalog: 4,status: 2)
      #     UserMailer.sample_email(@courses,'2019W Computer Science II (CS-1920-2)').deliver
      #     @courses.update(status: 1)
      # end

      # if Course.where(catalog: 1,status: 2).count > 0
      #     @courses = Course.where(catalog: 1,status: 2)
      #     UserMailer.sample_email(@courses,'2019W Computer Org. and Architecture (CS-2520-1)').deliver
      #     @courses.update(status: 1)
      # end
    end

  end

end
