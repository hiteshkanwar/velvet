module ApplicationHelper
	def link_urls_and_users s

	    #regexps
	    user = /@(\w+)/

	    #replace @usernames with links to that user
	    while s =~ user
	        s.sub! "@#{$1}", "<a href='http://tippinthevelvet.com/#{$1}' >@#{$1}</a>"
	    end

	     s

	end
end
