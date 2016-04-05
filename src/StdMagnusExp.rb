#
# StdMagnusExp.rb
#
# Time-stamp: <2016-04-04 01:42:57 (ryosuke)>
#
require('MagnusExp')
require('singleton')

#-----------------------------------------------
class StdMagnusExp
  include Expander, Singleton
  #---
  def expand(word)
    super(word).homo_part(0..4)
  end
  #---
  def higher(gen)
    unless gen.inverse? then
      Zero
    else
      ga = abelianize(gen)
      ga*ga + ga*ga*ga + ga*ga*ga*ga
    end
  end
end
#-----------------------------------------------

#==============
# End of File
#==============
