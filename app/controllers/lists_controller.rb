class ListsController < ApplicationController
	def index
		mechanize = Mechanize.new
		page = mechanize.get(ENV['TRAN'])
		n = page.at('p')
		@notice = n.text.strip if !n.nil?
		@schedules = Schedule.all
		@a = 'black'
	end


def fk
		mechanize = Mechanize.new
		c=''
			page = mechanize.get("https://www.springfieldspringfield.co.uk/view_episode_scripts.php?tv-show=girl-meets-world-2014&episode=s01e01")
				
		target = File.join(Rails.root, 'public',  "1.txt")
		File.open(target, "w+") do |f|
				 page.search('.scrolling-script-container').each do |cx|
				  f << cx.text.strip 
				  p cx.text.strip 
				  f << '\r\n'
			 end
			end
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

def save_olf
	target = File.join(Rails.root, 'public',  'olf.txt')
	File.open(target, "w+") do |f|


		Olf.all.each do |c|
				# binding.pry
				begin
				f << c.name
				f << "\n"
			  f << "<div class='main'>"

					c.olf_infos.each_with_index do |info,index|
					  f << "<div class='title#{index}'>"
						f <<  info.name
						f << '</div>'
					  f << "<div class='content#{index}'>"
						f << 	 info.content
						f << '</div>'
					end
			 f << "</div>"
			 f << "\n"
			 f << '</>'
			 f << "\n"

			rescue => ex
				target = File.join(Rails.root, 'public',  "olferror#{c.id}.txt")
				File.open(target, "w+") do |f|
					f << ex
						f << c.id
					end
			end
		end
	end

end

	def dictionary
 		# ary = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']

		get_size("https://www.larousse.fr/index/dictionnaires/francais-chinois/")
		mechanize = Mechanize.new
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

def get_section(uri)
	mechanize = Mechanize.new
	name = ''
	nc = ''
	#10350  10386
	Olf.where('id = 25395').each do |olf|
		begin
		page = mechanize.get("#{uri}#{olf.href}")

			if OlfInfo.where(olf_id: olf.id).size == 0

				 if page.search('.section a').size == 0
						c = page.search('.Definitions')[0].text.strip
							page.search('.Definitions li').each do |cx|
										c =  c.gsub(cx.text.strip,"<li class='DivisionDefinition'>#{cx.text.strip}</li>")
										cx.children.each do |children|
											if children.name =='span'
												c = c.gsub(children.text,"<span class='indicateurDefinition'>#{children.text}</span>")
											end
										end
							end

						OlfInfo.create(href: page['href'],olf_id: olf.id,content: c,name:'Définitions')

					else
						page.search('.section a').each_with_index do |page,index|
								pp = mechanize.get("#{uri}#{page['href']}"	)
									if page.text.strip == 'Définitions'
										c = pp.search('.Definitions')[0].text.strip
										pp.search('.Definitions li').each do |cx|
													c =  c.gsub(cx.text.strip,"<li class='DivisionDefinition'>#{cx.text.strip}</li>")
													cx.children.each do |children|
														if children.name =='span'
															c = c.gsub(children.text,"<span class='indicateurDefinition'>#{children.text}</span>")
														end
													end
										end
										name = 'Définitions'
									end
									if page.text.strip == 'Expressions'
											c = pp.search('.ListeLocutions')[0].text.strip
											pp.search('.ListeLocutions li').each do |cx|
														c =  c.gsub(cx.text.strip,"<li class='Locution'>#{cx.text.strip}</li>")
														cx.children.each do |children|
															if children.name =='span'
																c = c.gsub(children.text,"<span class='TexteLocution'>#{children.text}</span>")
															end
															if children.name =='h2'
																c = c.gsub(children.text,"<h2 class='AdresseLocution'>#{children.text}</h2>")
															end
														end
											end
											name = "Expressions"
									end
									if page.text.strip == 'Homonymes'
										if pp.search('.HomonymeDirects').size > 0
											c = pp.search('.HomonymeDirects')[0].text.strip
											pp.search('.HomonymeDirects li').each do |cx|
												c =  c.gsub(cx.text.strip,"<li class='Homonyme'>#{cx.text.strip}</li>")
												cx.children.each do |children|
													if children.name =='span'
														c = c.gsub(children.text,"<span class='CatGramHomonyme'>#{children.text}</span>")
													end

												end
											end
										end

										if pp.search('.HomonymeVariantes').size > 0
											c = ''
											nc = ''
												pp.search('.HomonymeVariantes ul').each do |cx|
													c =  "<ul class='VarianteHomonyme'>#{cx.text.strip}</ul>"
														cx.children.each do |children|
															if children.name =='li'
																c = c.gsub(children.text,"<li class='Homonyme'>#{children.text}</li>")
															end
														end
													nc = nc + c
												end
												c = nc
											end

											name = "Homonymes"
										end
									if  page.text.strip == 'Difficultés'
											c = pp.search('.Difficulte')[0].text.strip

											cx = 	pp.search('.TypeDifficulte').text.strip
											if cx.length > 0
												c =  c.gsub(cx,"<span class='TypeDifficulte'>#{cx}</span>")
											end
												cx = pp.search('.DefinitionDifficulte').text.strip
											if cx.length > 0
												c =  c.gsub(cx,"<span class='DefinitionDifficulte'>#{cx}</span>")
											end
											pp.search('.Difficulte ol li').each do |cx|
												c =  c.gsub(cx.text.strip,"<li class='NumDifficulte'>#{cx.text.strip}</li>")
												cx.children.each do |children|
													if children.name =='span'
														c = c.gsub(children.text,"<span class='AdresseDifficulte'>#{children.text}</span>")
													end
												end
											end
											name = "Difficultés"
									end

									if  page.text.strip == 'Synonymes'
											c = ''
											nc = ''
											pp.search('.SensSynonymes').each_with_index do |s,index|
													c =  "<div class='SensSynonymes'>"+ s.text+"</div>"
													s.children.each do |children|
														if children.name =='ul'
															children.children.each do |ochildren|
																if ochildren.name =='span'
																		c = c.gsub(ochildren.text,"<span class='LibelleSynonyme'>#{ochildren.text}</span>")
																end
																# if ochildren.name =='li'
																# 		c = c.gsub(ochildren.text,"<li class='Synonyme'>#{ochildren.text}</li>")
																# end
															end
														end

													end

												 nc = nc + c

												end

												c = nc
												name = "Synonymes"
										end
								OlfInfo.create(href: page['href'],olf_id: olf.id,content: c,name: name)
						end

					end

				end
				rescue => ex
					target = File.join(Rails.root, 'public',  "error#{olf.id}.txt")
					File.open(target, "w+") do |f|
						f << ex
							f << olf.id
						end
					end

	end
	end

	def olf
		# get_size_olf("https://www.larousse.fr/index/dictionnaires/francais/")
		# get_section("https://www.larousse.fr")
# p Olf.all.count
# NoticeWorker.perform_async("https://www.larousse.fr",30000,35000)
# Notice1Worker.perform_async("https://www.larousse.fr",10000,15000)
# Notice2Worker.perform_async("https://www.larousse.fr",20000,25000)
# Notice3Worker.perform_async("https://www.larousse.fr",35000,40000)
# Notice4Worker.perform_async("https://www.larousse.fr",15000,20000)
# Notice5Worker.perform_async("https://www.larousse.fr",25000,30000)

NoticeWorker.perform_async("https://www.larousse.fr",40000,45000)
Notice1Worker.perform_async("https://www.larousse.fr",45000,50000)
Notice2Worker.perform_async("https://www.larousse.fr",50000,55000)
Notice3Worker.perform_async("https://www.larousse.fr",55000,65000)
Notice4Worker.perform_async("https://www.larousse.fr",65000,75000)
Notice5Worker.perform_async("https://www.larousse.fr",75000,Olf.all.count)
	end

	def get_size(uri)
		ary = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
		mechanize = Mechanize.new

		ary.each do |ar|
			page = mechanize.get("#{uri}#{ar}/1")
			num = page.search('.pages a').size - 1
			num.times do |n|
				doit("#{uri}",ar,n+1)
			end
		end
	end

def collfe
#	get_size_collfe("https://www.collinsdictionary.com/browse/french-english/french-words-starting-with-")
	mechanize = Mechanize.new
	c=''
	g= ''
	Collinfe.all.each do |co|
		c = "<div class=name>#{co.name}</div>"
		page = mechanize.get(co.href)
		# binding.pry
		page.search('.homograph-entry .page').each do |en|
			x = en.search('.roundRed').size
			c += "<div class=count>#{x}星</div>"
			d = en.search('.content').text

			
 			plural =en.search('.content .gramGrp').text
 		
			sense = en.search('.content .sense').text
			en.search('.content .sense div').each do |t|
				d = d.gsub(t.text,"<div class='type'>#{t.text}</div>")
			end
if plural.size > 0 
			d = d.gsub(plural,"<div class='plural'>#{plural}</div>")
end
			copyright = en.search('.copyright').text
			d = d.gsub(copyright,"")
		
			d = d.gsub("googletag.cmd.push(function() { googletag.display('ad_contentslot_2'); });","")
			d = d.gsub("googletag.cmd.push(function() { googletag.display('ad_contentslot_1'); });","")
			# c = c+g
			c += d

		
		end
	# p c 
	CollinfeInfo.create(collinfe_id: co.id,content: c)

	end

	@co=c


end

def save_collfe
target = File.join(Rails.root, 'public',  'collfe.txt')
	File.open(target, "w+") do |f|


		Collinfe.all.each do |c|
				# binding.pry
				begin
				f << c.name
				f << "\n"
			  f << "<div class='main'>"

					c.collinfe_infos.each_with_index do |info,index|
				
						f << 	 info.content
				
					end
			 f << "</div>"
			 f << "\n"
			 f << '</>'
			 f << "\n"

			rescue => ex
				target = File.join(Rails.root, 'public',  "collfeerror#{c.id}.txt")
				File.open(target, "w+") do |f|
					f << ex
						f << c.id
					end
			end
		end
	end	
end
	def get_size_collfe(uri)
		 ary = ['b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
	
		mechanize = Mechanize.new
		ary.each do |ar|
			page = mechanize.get("#{uri}#{ar}")
			# binding.pry
			page.search('.browse-list li').each do |a|
				a.search('a').each do |hr|
					# mechanize = Mechanize.new
		
					page2 = mechanize.get(hr['href'])
					page2.search('.browse-list li').each do |a|
						a.search('a').each do |hr|
							# binding.pry
							# p hr['title']
							# p hr['href']
							 Collinfe.create(name: hr['title'],href: hr['href'])
						end
					end
				end
			
			end
		end
end

	def get_size_olf(uri)
		ary = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
		mechanize = Mechanize.new

		ary.each do |ar|
			page = mechanize.get("#{uri}#{ar}/1")
			num = page.search('.pages a').size
			num.times do |n|
				doitolf("#{uri}",ar,n+1)
			end
		end
	end

	def doitolf(uri,al,num)
			mechanize = Mechanize.new
			page = mechanize.get("#{uri}#{al}/#{num}")
			page.search('.content a').each_with_index do |i,index|
				 Olf.create(name: i.text.strip,href: i['href'])
			end
	end

	def doit(uri,al,num)
			mechanize = Mechanize.new
			page = mechanize.get("#{uri}#{al}/#{num}")
			page.search('.content a').each_with_index do |i,index|
				 Card.create(name: i.text.strip,href: i['href'])
			end
	end


end
