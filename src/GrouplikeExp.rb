#
# GrouplikeExp.rb
#
# Time-stamp: <2014-08-06 13:35:11 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../lib/GLA/src/')

require('FormalSum')
require('LieBracket')
require('MagnusExp')
require('singleton')

#-----------------------------------------------
class GrouplikeExp
  include Expander, Singleton
  
  def initialize(m=3)
    @mod_deg = m
    @lb1 = LieBracket.new('a','b')
    @lb2 = LieBracket.new('s','t')
    @lb3 = LieBracket.new('x','y')
  end
  attr_accessor :mod_deg

  def higher(*gfs)
    Zero
  end

  def higher_inverse(gfs)
    gfs*gfs-gfs*gfs*gfs
  end

  def log2(gen)
    return case gen.to_char
           when 'a' then @lb1
           when 'b' then @lb1*(-1)
           when 's' then @lb2
           when 't' then @lb2*(-1)
           when 'x' then @lb3
           when 'y' then @lb3*(-1)
           else Zero end
  end
end
#-----------------------------------------------

#==============
# End of File
#==============
