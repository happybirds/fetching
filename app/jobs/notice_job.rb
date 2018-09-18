class NoticeJob

  def perform
      ms = ['Mon','Tue','Wed',"Thu",'Fri']
    if Time.now.strftime('%H').to_i > 7 && Time.now.strftime('%H').to_i < 24 && ms.include?(Date.today.strftime("%a"))
    
     mechanize = Mechanize.new
    #
    page = mechanize.post(ENV['M_URI'])

    form = page.forms.first
    #
    form['UserName'] = 'ADDS\\'+ENV['U_USER']
    form['Password'] = ENV['U_PWD']
    form['AuthMethod'] = 'FormsAuthentication'
    #
    page = form.submit

    mainpage = page.form.submit

    ca = mainpage.link_with(text:'View All').click


    ca_ary = []
    ca.search('.itx').each_with_index do |i,index|
    		ca_ary.push(i.text.strip)
    end


    ca_ary.each_with_index do |b,index|
    	if Notice.find_by_title(b).nil?
    		Notice.create(status: 2,title: b)
    	end
    end

    if Notice.where(status: 2).count > 0
    			@notices = Notice.where(status: 2)
    			UserMailer.notice_email(@notices,'Announcements').deliver
    			@notices.update(status: 1)
    	end
  end
end

end
