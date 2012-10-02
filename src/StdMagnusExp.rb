#
# StdMagnusExp.rb
#
# Time-stamp: <2012-10-02 13:29:53 (ryosuke)>
#

require('MagnusExp')
require('singleton')

#-----------------------------------------------
class StdMagnusExp 
  include Expander, Singleton
  
  def initialize(m=4)
    @mod_deg = m
  end
  attr_accessor :mod_deg

  def higher(*gfs)
    Zero
  end

  def higher_inverse(gfs)
    gfs*gfs-gfs*gfs*gfs
  end

end
#-----------------------------------------------

#==============
# End of File
#==============
