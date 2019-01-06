class CourseJob

  def perform
        ms = ['Mon','Tue','Wed',"Thu",'Fri']
       if Time.now.strftime('%H').to_i > 7 && Time.now.strftime('%H').to_i < 23 && ms.include?(Date.today.strftime("%a"))
      mechanize = Mechanize.new

      page = mechanize.post(ENV['U_URI'])

      form = page.forms.first

      form['username'] = ENV['U_USER']
      form['password'] = ENV['U_PWD']

      page = form.submit

      dashboard = page.link_with(text: 'Dashboard').click

      bio_ay = []
      phy_ay =[]
      cs_ay =[]
      math_ay=[]

      bio = dashboard.link_with(text: '2019W CS-1610-1').click

      bio.search('.instancename').each do |i|
         bio_ay.push(i.text.strip)
      end

      cs = dashboard.link_with(text: '2019W CS-1920-2').click

      cs.search('.instancename').each do |i|
        cs_ay.push(i.text.strip)
      end

      math = dashboard.link_with(text: '2019W CS-2520-1').click

      math.search('.instancename').each do |i|
        math_ay.push(i.text.strip)
      end


      # phy = dashboard.link_with(text: '2018F Life in the Universe (PHYS-1510-1)').click

      # phy.search('.instancename').each do |i|
      #   phy_ay.push(i.text.strip)
      # end

      bio_ay.each do |b|
        if Course.find_by_title(b).nil?
          Course.create(title: b,catalog: 3,status: 2)
        end
      end

      # phy_ay.each do |b|
      #   if Course.find_by_title(b).nil?
      #     Course.create(title: b,catalog: 2,status: 2)
      #   end
      # end

      cs_ay.each do |b|
        if Course.find_by_title(b).nil?
          Course.create(title: b,catalog: 4,status: 2)
        end
      end

      math_ay.each do |b|
        if Course.find_by_title(b).nil?
          Course.create(title: b,catalog: 1,status: 2)
        end
      end


      if Course.where(catalog: 1,status: 2).count > 0
          @courses = Course.where(catalog: 3,status: 2)
          UserMailer.sample_email(@courses,'2019W Digital Systems (CS-1610-1)').deliver
          @courses.update(status: 1)
      end

      # if Course.where(catalog: 2,status: 2).count > 0
      #     @courses = Course.where(catalog: 2,status: 2)
      #     UserMailer.sample_email(@courses,'Life in the Universe (PHYS-1510-1)').deliver
      #     @courses.update(status: 1)
      # end

      if Course.where(catalog: 3,status: 2).count > 0
          @courses = Course.where(catalog: 4,status: 2)
          UserMailer.sample_email(@courses,'2019W Computer Science II (CS-1920-2)').deliver
          @courses.update(status: 1)
      end

      if Course.where(catalog: 4,status: 2).count > 0
          @courses = Course.where(catalog: 1,status: 2)
          UserMailer.sample_email(@courses,'2019W Computer Org. and Architecture (CS-2520-1)').deliver
          @courses.update(status: 1)
      end
    end

  end

end
