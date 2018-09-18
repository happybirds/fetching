class CampuJob

  def perform
    ms = ['Mon','Tue','Wed',"Thu",'Fri']
    if Time.now.strftime('%H').to_i > 7 && Time.now.strftime('%H').to_i < 24 && ms.include?(Date.today.strftime("%a"))
      mechanize = Mechanize.new
      page = mechanize.get(ENV['HNEW'])
      ary=[]
      _ary=[]
    page.search('.field-content').each_with_index do |c,index|
    if index % 5 == 0 
      _ary=[]
    end
    if index % 5 == 0 
      if !page.search('.field-content')[index].search('img').nil?
        _ary.push(page.search('.field-content')[index].search('img')[0]['src'])
      else
        _ary.push(0)
      end

    elsif  index % 5 == 1 
      _ary.push(ENV['HROOT']+page.search('.field-content')[index].search('a')[0]['href'])
      _ary.push(c.text)

    else
      _ary.push(c.text)
    end

    if index % 5 == 0 
      ary.push(_ary)

    end

  end

    ary.each_with_index do |b,index|
      
      if Campu.find_by_title(b[2]).nil?
        Campu.create(status: 2,image_uri: b[0],title_uri:b[1],title:b[2],send_time:b[3],content:b[4])
      end
    end

    if Campu.where(status: 2).count > 0
          @campus = Campu.where(status: 2)
          UserMailer.campu_email(@campus,'UPEI In the News').deliver
          @campus.update(status: 1)
      end
        

    end
  end

end
