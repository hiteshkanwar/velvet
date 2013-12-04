module EmojiHelper

 def emojify(content)
    content.to_str.gsub(/:([a-z0-9\+\-_]+):/) do |match|
      if Emoji.names.include?($1)
      	family = Emoji.family($1)
      	puts "family #{family}"
      	   # If emoji if free  / If user as the all pack Emoji / If user as the family pack of current emoji	
      	if family == "free" || @current_user.emojis.find_by_name("all") || @current_user.emojis.find_by_name(family)
        	'<img alt="' + $1 + '" width="30" src="' + asset_path("emoji/#{$1}.png") + '" style="margin-left:6px;margin-right:6px;vertical-align:middle" />'
        else
        	""
        end
      else
        match
      end
    end.html_safe if content.present?
  end

end