#
# GrouplikeExp.rb
#
# Time-stamp: <2014-08-08 10:12:40 (ryosuke)>
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
    @lb1 = LieBracket.new('a','b')*(1/2r)
    @lb2 = LieBracket.new('s','t')*(1/2r)
    @lb3 = LieBracket.new('x','y')*(1/2r)
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
           when 'a','B' then @lb1
           when 'b','A' then @lb1*(-1)
           when 's','T' then @lb2
           when 't','S' then @lb2*(-1)
           when 'x','Y' then @lb3
           when 'y','X' then @lb3*(-1)
           else Zero end
  end
end
#-----------------------------------------------

#==============
# End of File
#==============
