class Emoji < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user

  def self.names
    "69, anal-beads, anal-plug, anal1, anal2, bat-weapon, beer, blood, blowjob-guys, blowjob, bomb, bong, brass-knuckles, bridge, bukkake, casino, chair-position, cocaine, cocaine2, cocksock, cocktail, cocktails, cowgirl, crack, crosshairs, crosshairs2, cum-swapping, cunnilingus, desert, doggy-style, double-penetration, ear, finger-fucking, finger-sucking, fisting, footjob1, footjob2, forest, froggy-style, gym, gym2, handgun, handjob, heroin, high-rise, home, huffing, huffing2, huffing3, island, knife, mansion, martini-short, martini-tall, meth, meth2, missionary, molly, mountains, peeing-girl, peeing-girl2, peeing-man, pills, pole, pole2, porn-dvd, porn-dvd2, porn-set, punch, red-eyes, reverse-cowgirl, rifle, rimjob, rock-weapon, rolled-up-bill, rolled-up-bill2, shit, snow, spoon-position, standing-cowgirl, standing-reverse-cowgirl, store, stripper, sword, target, Tits, toe-sucking, vomit-man, vomit-puddle, weed, whipits, wine, middle-finger, bukkake3"
  end

  def self.family(name)
    family = { 
           
         
           :fetish  =>  "finger-fucking, footjob1, footjob 2, peeing-girl 2, peeing-man, toe-sucking, bukkake",
           :porn  =>  "porn-dvd, porn-dvd 2, porn-set, stripper, pole, pole 2",
           :street  =>  "rolled-up-bill, rolled-up-bill 2, molly, red-eyes, whip its, huffing, heroin, cocaine, cocaine 2, crack, meth, meth 2, pills",
           :free  =>  
            "cum-swapping, rimjob, middle-finger, 69, anal-beads, anal-plug, anal 1, anal 2, beer, blood, blow job-guys, blow job, bomb, bong, bridge, casino, chair-position, cocksock, cocktail, cocktails, cowgirl, crosshairs, crosshairs 2, cunnilingus, desert, doggy-style, double-penetration, ear, finger-sucking, fisting, forest, froggy-style, gym, gym2, hand job, high-rise, home, huffing 2, island, mansion, martini-short, martini-tall, missionary, mountains, punch, reverse-cowgirl, shit, snow, spoon-position, standing-cowgirl, standing-reverse-cowgirl, store, Tits, vomit-man, vomit-puddle, weed",
           :weapon=> "bat-weapon, brass-knuckles, bomb, handgun, knife, rifle, rock-weapon, sword, target" 
       

        }
    family.each { |family, emojis|

      #puts "key: #{family} value: #{emojis}"
      return family.to_s if emojis.include?(name)

    }

  end
end