path = Dir.pwd + "/"
file = path + "dedication.md"
text = File.read(file)

stanzas = text.scan(/(\d.*?)\n\n/m)
print stanzas # this is just a test

# The following will grab only single-line annotations! To allow for multi-line annotations, leave a blank line between annotations and change the regex to:
# /^\|\*\|(.*?)\n\n/m 
annotations = text.scan(/^\|\*\|(.*?)\n/)
print annotations # this is just a test
