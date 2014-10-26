#
# SymplecticExp.rb
#
# Time-stamp: <2014-02-04 11:49:27 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'./../lib/GLA/src/')

require('LieBracket')

require('MagnusExp')
require('singleton')

#-----------------------------------------------
class SympMagnusExp 
  include Expander, Singleton
  
  def initialize(m=2)
    @mod_deg = m
  end
  attr_accessor :mod_deg
  
  def higher(gfs)
    #--TODO-- How should the higher part of symplectic expansions be written for a given Generator?
    # lb = LieBracket.new(gfs, gfs).expand
    # return lb+LieBracket.new(gfs,lb).expand
    #return gfs*gfs*2
    return (1/2)*gfs*gfs #+log2(gfs)
  end
  
  def higher_inverse(gfs) 
    #--TODO--
    (1/2)*gfs*gfs
  end

end
#-----------------------------------------------

#==============
# End of File
#==============
