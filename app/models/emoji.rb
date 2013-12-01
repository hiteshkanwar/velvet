class Emoji < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user

  def self.names
  	"69, anal-beads, anal-plug, anal1, anal2, bat-weapon, beer, blood, blowjob-guys, blowjob, bomb, bong, brass-knuckles, bridge, bukkake, casino, chair-position, cocaine, cocaine2, cocksock, cocktail, cocktails, cowgirl, crack, crosshairs, crosshairs2, cum-swapping, cunnilingus, desert, doggy-style, double-penetration, ear, finger-fucking, finger-sucking, fisting, footjob1, footjob2, forest, froggy-style, gym, gym2, handgun, handjob, heroin, high-rise, home, huffing, huffing2, huffing3, island, knife, mansion, martini-short, martini-tall, meth, meth2, missionary, molly, mountains, peeing-girl, peeing-girl2, peeing-man, pills, pole, pole2, porn-dvd, porn-dvd2, porn-set, punch, red-eyes, reverse-cowgirl, rifle, rimjob, rock-weapon, rolled-up-bill, rolled-up-bill2, shit, snow, spoon-position, standing-cowgirl, standing-reverse-cowgirl, store, stripper, sword, target, Tits, toe-sucking, vomit-man, vomit-puddle, weed, whipits, wine, middle-finger, bukkake3"
  end

  def self.family(name)
  	family = { 
  			   :free 	=> 	
  			   	"69, anal-beads, anal-plug, anal1, anal2, bat-weapon, beer, blood, blowjob-guys, blowjob, bomb, bong, brass-knuckles, bridge, bukkake, casino, chair-position, cocaine, cocaine2, cocksock, cocktail, cocktails, cowgirl, crack, crosshairs, crosshairs2, cunnilingus, desert, doggy-style, double-penetration, ear, finger-sucking, fisting, forest, froggy-style, gym, gym2, handgun, handjob, high-rise, home, huffing, huffing2, island, knife (1), knife, mansion, martini-short, martini-tall, meth, meth2, missionary, mountains, peeing-girl, pills, pole, pole2, porn-set, punch, reverse-cowgirl, rifle, rock-weapon, rolled-up-bill2, shit, snow, spoon-position, standing-cowgirl, standing-reverse-cowgirl, store, stripper, sword, target, Tits, vomit-man, vomit-puddle, weed, wine, bukkake3, middle-finger", 
  			   
  			   :fetish  =>	"finger-fucking, footjob1, footjob2, peeing-girl2, peeing-man, toe-sucking",
  			   :porn 	=> 	"porn-dvd, porn-dvd2, cum-swapping",
  			   :street 	=> 	"rolled-up-bill, molly,red-eyes,whipits,huffing3,heroin, rimjob"
  			}
  	family.each { |family, emojis|

  		#puts "key: #{family} value: #{emojis}"
  		return family.to_s if emojis.include?(name)

  	}

  end
end
