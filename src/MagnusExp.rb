#
# MagnusExp.rb
#
# Time-stamp: <2016-04-04 16:38:09 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../lib/GLA/src/')

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
      gen = word
      marr << mapping(gen)
    elsif word.is_a?(Word)
      word.contract
      word.each_gen{ |gen| marr << mapping(gen) }
    elsif word.is_a?(String)
      self.expand(Word.new(word))
    else
      raise ArgumentError, "The argument is not a Word."
    end
    #
    marr.reverse!
    until marr.size == 1
      marr << (marr.pop)*(marr.pop)
      #marr.last.terms.delete_if { |t| t.degree >= mod_deg }
    end
    #
    return marr[0].simplify
  end

  def higher(gen)
  end

  private
  def abelianize(gen)
    myterm = Term.new(gen.letter.upcase)
    FormalSum.new(myterm)*(gen.inverse? ? -1 : 1)
  end

  def first_deg(gen)
    abelianize(gen)
  end

  def mapping(gen)
    # maps a Generator x to a FormalSum 1+X+higher(x).
    # the method higher(g) will be defined in a class which includes this module.
    #---
    gen = Generator.new(gen[0]) if gen.is_a?(String)  # Strings are acceptable
    raise ArgumentError, "The argument is not a Generator" unless gen.is_a?(Generator)
    #---
    return (gen.to_char == '1') ? One : One + first_deg(gen) + self.higher(gen)
  end
  #
end
#-----------------------------------------------

#==============
# End of File
#==============
