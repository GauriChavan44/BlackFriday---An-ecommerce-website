###################################################
# Common shared functions for all test suites
###################################################

######################################
def generate_random_string(length=15)
  chars = 'abcdefghjkmnpqrstuvwxyz'
  Array.new(length) { chars[rand(chars.length)].chr }.join
end
