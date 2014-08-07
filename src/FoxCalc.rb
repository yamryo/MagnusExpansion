#
# FoxCalc.rb
#
# Time-stamp: <2014-08-07 14:50:33 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../lib/GLA/src/')

require('FormalSum')

module FoxCalculator
  extend self

  #-----
  Zero = FormalSum::Zero
  One = FormalSum::One

  #-----
  def initialize(*arg)
    if ( arg.size >0 and Generator === arg[0] ) then
      @generator = arg[0]
    else
      @generator = Generator.new('1')
    end
    @generator.invert! if @generator.inverse? 
  end
  attr_reader :generator

  #-----
  def [](gen)
    @generator = case gen
                 when Generator then gen      
                 when String then Generator.new(gen[0])
                 else Generator.new('1')
                 end
    return self
  end

  def send(word)
    if word.kind_of?(Generator) then
      myarr ||= calc(word)
    else
      raise ArgumentError, "The argument is not a Word." unless word.kind_of?(Word)

      word.contract
      myarr = [Zero, One]
      word.each_char do |chr|
        t = calc(Generator.new(chr))
        last = myarr.pop
        myarr.concat [last*t, last*Term.new(chr)]
      end
      myarr.pop
    end
    #
    return FormalSum.new(myarr).to_s
  end

  #-----
  private
  def calc(gen) 
    # (del/del(@generator))(gen) returns Zero, One or Term '-#{gen.to_c}' 
    # gen = Generator.new(gen[0]) if gen.kind_of?(String)  # can accept a string
    raise ArgumentError, "The argument is not a Generator." unless gen.kind_of?(Generator)

    if @generator.letter == gen.letter then
      (!gen.inverse?) ? One : Term.new(gen.to_char, -1)
    else 
      return Zero
    end
  end
  #
end

#==============
# End of File
#==============
