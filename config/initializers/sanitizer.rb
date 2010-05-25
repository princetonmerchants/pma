# The Comments Extension uses this option to clean out unwanted elements from the comments.
# The example output for each option is the result of sanitization for this text:
#
# '<b><a href="http://foo.com/">foo</a></b><img src="http://foo.com/bar.jpg" />'
#
# Uncomment one of the options below to choose your preference. By default, RELAXED is used.
# For more information about your options, please see the Sanitize documentation:
# http://rgrove.github.com/sanitize/

COMMENT_SANITIZER_OPTION = 
  Sanitize::Config::RELAXED # Gives you '<b><a href="http://foo.com/">foo</a></b><img src="http://foo.com/bar.jpg" />'
  # Sanitize::Config::BASIC # Results in '<b><a href="http://foo.com/" rel="nofollow">foo</a></b>'
  # Sanitize::Config::RESTRICTED # This results in '<b>foo</b>'
  
  # Or you may create your own sanitization rules. Uncomment all the lines below and edit them as you need.
  # {:elements => ['a', 'span'],
  #  :attributes => {'a' => ['href', 'title'], 'span' => ['class']},
  #  :protocols => {'a' => {'href' => ['http', 'https', 'mailto']}}}
