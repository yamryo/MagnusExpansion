#
# SympMagnusExp.rb
#
# Time-stamp: <2012-10-02 11:41:03 (ryosuke)>
#

require('MagnusExp')
require('singleton')

#-----------------------------------------------
class SympMagnusExp 
  include Expander, Singleton
  
  def initialize(m=4)
    @mod_deg = m
  end
  attr_accessor :mod_deg
  
  def higher(gen)
    #--TODO-- How should the higher part of symplectic expansions be written for a given Generator?
    deg2, deg3 = Term.new(gen*gen, 1), Term.new(gen*gen*gen, 1)
    FormalSum.new(deg2,deg3)
  end
  
  def higher_inverse(gen) 
    #--TODO--
  end

end
#-----------------------------------------------

#==============
# End of File
#==============
