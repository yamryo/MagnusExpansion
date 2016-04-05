#
# FoxCalc.rb
#
# Time-stamp: <2016-04-04 11:25:59 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../lib/GLA/src/')

require('FormalSum')

module FoxCalculator
  extend self

  #-----
  Zero = FormalSum::Zero
  One = FormalSum::One

  ErrMsg01 = "You should set a Generator to @generator."
  ErrMsg02 = "You should set a Generator which is not inverse."
  #attr_reader :generator

  #-----
  def [](gen)
    gen = case gen
          when Generator then gen
          when String then Generator.new(gen[0])
          else
            raise ArgumentError, ErrMsg01
          end
    raise ArgumentError, ErrMsg02 if gen.inverse?
    @generator ||= gen
    return self
  end

  def derivative(word)
    raise ArgumentError, ErrMsg01 if @generator.nil?
    if (word.is_a? Generator) then
      result = calc(word)
    else
      raise ArgumentError, "The argument is not a Word." unless word.is_a? Word
      fs_arr = [Zero, One]
      (word.contract).each_gen do |gen|
        fs = calc(gen)
        last = fs_arr.pop
        fs_arr.concat [last*fs, last*FormalSum.new(gen.to_char)]
      end
      fs_arr.pop
      result = fs_arr.inject(Zero) { |sum,fs| sum + fs }
    end
    #
    return result
  end

  #-----
  private
  def calc(gen)
    # (del/del(@generator))(gen) returns Zero, One or a FormalSum '-#{gen.to_char}'
    raise ArgumentError, "The argument is not a Generator." unless gen.is_a? Generator

    if @generator.letter == gen.letter then
      (!gen.inverse?) ? One : FormalSum.new("-#{gen.to_char}")
    else
      return Zero
    end
  end
  #
end

#==============
# End of File
#==============
