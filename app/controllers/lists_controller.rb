class ListsController < ApplicationController
	def index
		mechanize = Mechanize.new
		page = mechanize.get(ENV['TRAN'])
		n = page.at('p')
		@notice = n.text.strip if !n.nil?
		@schedules = Schedule.all
		@a = 'black'
	end

def save_dir
	target = File.join(Rails.root, 'public',  'dir.txt')
	File.open(target, "w+") do |f|

		CardInfo.all.each do |c|
				begin
				f << c.card.name
				f << "\n"
				 f << "<div class='main'>"
			 c.content.split(/\r\n/).each do |s|
				 f << '<div>'
					f << s.strip
					f << '<br/>'
					f << '</div>'
			 end
			 f << "</div>"
			 f << "\n"
			 f << '</>'
			 f << "\n"

			rescue => ex
				target = File.join(Rails.root, 'public',  "error#{c.id}.txt")
				File.open(target, "w+") do |f|
						f << c.id
					end
			end
		end
	end

end

	def dictionary
 		ary = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
		mechanize = Mechanize.new

		ary.each do |ar|
			page = mechanize.get("https://www.larousse.fr/index/dictionnaires/francais-chinois/#{ar}/1")
			num = page.search('.pages a').size - 1
			num.times do |n|
				doit(ar,n+1)
			end
		end
		c=''



		Card.where(id: 1026).each do |card|
			 if !CardInfo.find_by_card_id(card.id)
				 begin
			page = mechanize.get("https://www.larousse.fr/#{card.href}")

			 c = page.search('.article_bilingue')[0].text.strip
			 page.search('.CategorieGrammaticale').each do |cx|
			 c =  c.gsub(cx.text.strip,"<span class='CategorieGrammaticale'>#{cx.text.strip}</span>")
			 end

			 page.search('.lienconj').each do |cx|
			 c =  c.gsub(cx.text.strip," ")
			 end

			 page.search('.Indicateur').each do |cx|
			 c =  c.gsub(cx.text.strip,"<span class='Indicateur'>#{cx.text.strip}</span>")
			 end

			 page.search('.Locution2').each do |cx|
			 c =  c.gsub(cx.text.strip,"<span class='Locution2'>#{cx.text.strip}</span>")
			 end

			 page.search('.Traduction2').each do |cx|
			 c =  c.gsub(cx.text.strip,"<span class='Traduction2 '>#{cx.text.strip}</span>")
			 end


			 page.search('.Traduction').each do |cx|
			 c =  c.gsub(cx.text.strip,"<span class='Traduction'>#{cx.text.strip}</span>")
			 end

			 		CardInfo.create(card_id: card.id,content: c)

				rescue => ex
					target = File.join(Rails.root, 'public',  "error#{card.id}.txt")
					File.open(target, "w+") do |f|
							f << card.id
						end
					end
		 	 end
		end


	end


	def doit(al,num)
			mechanize = Mechanize.new
			page = mechanize.get("https://www.larousse.fr/index/dictionnaires/francais-chinois/#{al}/#{num}")
			page.search('.content a').each_with_index do |i,index|
				 Card.create(name: i.text.strip,href: i['href'])
			end
	end


end
