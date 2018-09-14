
class ListsController < ApplicationController
	def index
		mechanize = Mechanize.new
		page = mechanize.get(ENV['TRAN'])
		n = page.at('p')
		@notice = n.text.strip if !n.nil?
		@schedules = Schedule.all
		@a = 'black'
	end

def my

	mechanize = Mechanize.new
	#
	page = mechanize.post(ENV['M_URI'])

	form = page.forms.first
	#
	form['UserName'] = "ADDS\\wluo2"
	form['Password'] = "Footfall1230"
	form['AuthMethod'] = 'FormsAuthentication'
	#
	page = form.submit

	mainpage = page.form.submit

	ca = mainpage.link_with(text:'View All').click
	ca_ary = []
	ca.search('.itx').each_with_index do |i,index|
		ca_ary.push(i.text.strip)
	end


end



def campus

	mechanize = Mechanize.new
	#
	page = mechanize.get('http://www.upei.ca/communications/news')

page.search('.field-content').each do |c|
p c.text.strip
end
binding.pry


end


end
