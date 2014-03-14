module ApplicationHelper
	def link_urls_and_users s

	    #regexps
	    user = /@(\w+)/
	    hashtags = /#(\w+)/
	 
	    #replace @usernames with links to that user
	    while s =~ user
	        s.sub! "@#{$1}", "<a href='/#{$1}'>[at]#{$1}</a>"
	    end

	    while s =~ hashtags
	       s.sub! "##{$1}", "<a href='/search/#{$1}'>[hash]#{$1}</a>"
	    end

	    s.gsub("[hash]", "#").gsub("[at]", "@")

	end

	def pack_price name
		'199'
	end
	def private_profile
				
		if 	@user !=@current_user	
			if @user.private  
				return @current_user.is_following.include? @user
			else
				return true
			end
		else
			return true
		end	
					
	end	
	def private_search (user)
				
		if 	user !=@current_user	
			if user.private  
				return @current_user.is_following.include? user
			else
				return true
			end
		else
			return true
		end	
					
	end	




	def check(params)
		@current_user.send(params) ? "checked" : nil
	end

	def to_date(date)
		date.strftime("%d %b. %Y")
	end

	def linkify(string)
		string_with_href = find_links!(string)
		string_with_href.nil? ? string : string_with_href
	end

	def find_links!(string)
		string.gsub!(/\b((https?:\/\/|ftps?:\/\/|mailto:|www\.)([A-Za-z0-9\-_=%&@\?\.\/]+))\b/) {

			match = $1
			tail  = $3

			case match
			when /^www/     then  "<a href=\"http://#{match}\">#{match}</a>"
			when /^mailto/  then  "<a href=\"#{match}\">#{tail}</a>"
			else                  "<a href=\"#{match}\">#{match}</a>"
			end

		}
	end
	 def block_user_detail(user,current_user)

     	 if BlockUser.find_by_blocked_id_and_user_id(@user.id, @current_user.id).present?
    	 	return true
    	 else
    	 	return false
    	 end
    end
    def unblock_user_detail(user,current_user)
    	if !BlockUser.find_by_user_id_and_blocked_id(@user.id, @current_user.id).present?
    		return true
    	 else
    	 	return false
    	 end
    end

end


