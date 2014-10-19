require 'open-uri'
# file_contents = open('local-file.txt') { |f| f.read }
web_contents  = open('https://rawgit.com/azangru/donjuan-literal-translation/master/dedication.txt') {|f| f.read }
puts web_contents
