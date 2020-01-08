class Section

  def self.get_section(uri,count_min,count_max)
  	mechanize = Mechanize.new
  	name = ''
  	nc = ''
  	#10350  10386
  	Olf.where("id >= #{count_min} && id < #{count_max}").each do |olf|
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

  				OlfInfo.create(olf_id: olf.id,content: c,name:'Définitions')

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
  								# c = pp.search('.HomonymeVariantes')[0].text.strip
  								pp.search('.HomonymeVariantes ul').each do |cx|
  									c =  "<ul class='VarianteHomonyme'>#{cx.text.strip}</ul>"

  									cx.children.each do |children|
  										# if children.name =='span'
  										# 	c = c.gsub(children.text,"<span class='CatGramHomonyme'>#{children.text}</span>")
  										# end
  										if children.name =='li'



  											c = c.gsub(children.text,"<li class='Homonyme'>#{children.text}</li>")
  									# 	# 		# children.children.each do |ochildren|
  									# 	# 		# 	if ochildren.name =='span'
  									# 	# 		# 		c = c.gsub(ochildren.text,"<span class='CatGramHomonyme'>#{ochildren.text}</span>")
  									# 	# 		# 	end
  									# 	# 		# end
  										end

  									end
  									nc = nc + c
  								end
  								c = nc
  								# pp.search('.HomonymeVariantes li').each do |cx|
  								# 	c =  c.gsub(cx.text.strip,"<li class='Homonyme'>#{cx.text.strip}</li>")
  								# end
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

  						olf = OlfInfo.create(href: page['href'],olf_id: olf.id,content: c,name: name)
              p olf.olf_id
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
end
