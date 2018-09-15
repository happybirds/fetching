class ListsController < ApplicationController
	def index
		mechanize = Mechanize.new
		page = mechanize.get(ENV['TRAN'])
		n = page.at('p')
		@notice = n.text.strip if !n.nil?
		@schedules = Schedule.all
		@a = 'black'
	end

end