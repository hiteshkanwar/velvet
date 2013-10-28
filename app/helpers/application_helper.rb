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
end
