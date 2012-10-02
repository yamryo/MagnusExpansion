#
# MagnusExp.rb
#
# Time-stamp: <2012-10-02 13:27:33 (ryosuke)>
#
$LOAD_PATH.push File.expand_path('~/rubyP/GLA/src')

require('FormalSum')

#-----------------------------------------------
module Expander
  extend self
  
  Zero = FormalSum::Zero
  One = FormalSum::One

  def expand(word)
    marr = []
    #
    if word.is_a?(Generator) then
      marr << self.map(word)
    elsif word.is_a?(Word) 
      word.contract
      word.each_char{ |chr| marr << self.map(Generator.new(chr)) }
    else
      raise ArgumentError, "The argument is not a Word."
    end
    #
    marr.reverse!
    until marr.size == 1
      marr << (marr.pop)*(marr.pop)
      marr.last.terms.delete_if { |t| t.degree >= mod_deg }
    end
    #
    return marr[0].simplify
  end
  
  def map(gen)
    # maps a Generator x to a FormalSum 1+X+higher(x).
    # higher(g) will be a method of a class which includes this module. higher_inverse(g) too.
    #
    gen = Generator.new(gen[0]) if gen.is_a?(String)  # Strings are acceptable
    raise ArgumentError, "The argument is not a Generator" unless gen.is_a?(Generator)
    #
    g = FormalSum.new(Term.new(gen.letter))
    fsOne = FormalSum.new(One)
    return case gen.inverse?
           when false then fsOne + g + higher(g)
           when true then fsOne - g + higher_inverse(g)
           when nil then fsOne
           else raise Error end
  end
  #
end
#-----------------------------------------------

#==============
# End of File
#==============
