#
# SympMagnusExp.rb
#
# Time-stamp: <2012-10-02 14:05:51 (ryosuke)>
#
$LOAD_PATH.push File.expand_path('~/rubyP/GLA/src')

require('LieBracket')

require('MagnusExp')
require('singleton')

#-----------------------------------------------
class SympMagnusExp 
  include Expander, Singleton
  
  def initialize(m=4)
    @mod_deg = m
  end
  attr_accessor :mod_deg
  
  def higher(gfs)
    #--TODO-- How should the higher part of symplectic expansions be written for a given Generator?
    # lb = LieBracket.new(gfs, gfs).expand
    # return lb+LieBracket.new(gfs,lb).expand
    return gfs*gfs*2
  end
  
  def higher_inverse(gfs) 
    #--TODO--
    gfs*gfs
  end

end
#-----------------------------------------------

#==============
# End of File
#==============
