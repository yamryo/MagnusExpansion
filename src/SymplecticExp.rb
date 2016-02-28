#
# SymplecticExp.rb
#
# Time-stamp: <2016-02-28 17:20:58 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../lib/GLA/src/')

require('FormalSum')
require('LieBracket')
require('MagnusExp')
require('singleton')

#-----------------------------------------------
class SymplecticExp
  include Expander, Singleton

  Default_symp_gens = [%w[a, b], %w[s t], %w[x y]]

  def initialize(pairs_of_gens=Default_symp_gens, m=3)
    @mod_deg = m
    @symp_pairs = pairs_of_gens
    #---
    @base = []
    @symp_pairs.each do |pair|
      @base << LieBracket.new(pair[0], pair[1])*(1/2r)
    end
  end
  attr_accessor :mod_deg

  def higher(*gfs)
    Zero
  end

  def higher_inverse(gfs)
    gfs*gfs-gfs*gfs*gfs
  end

  def log2(word)
    lb_arr = []
    case word
    when Generator then
      return log2_calc(word)
    when Word, String then
      word = Word.new(word) unless word.kind_of?(Word)
      if word.length == 1
        lb_arr << log2_calc(Generator.new(word))
      else
        first_gen = word.gen_at(0) # the first letter
        word.slice!(0,1) # the rest of the word
        #binding.pry
        #---
        lb_arr << self.log2(first_gen)
        #---
        wa = ['|'+first_gen.to_char.downcase+'|','0']
        word.each_gen do |g|
          unless first_gen =~ g then
            wa[1] = '|'+g.to_char.downcase+'|'
            cf = (1/2r)*((first_gen.inverse?) ? -1 : 1)*((g.inverse?) ? -1 : 1)
            lb_arr << LieBracket.new(wa[0], wa[1])*cf
          end
        end
        #---
        lb_arr << self.log2(word)
      end
      #---
      return lb_arr.flatten
      #return lb_arr.flatten.sort{|a, b| a.inspect_couple <=> b.inspect_couple }
    else Zero
    end
  end
  #
  def log2_simplify(word)
    lb_arr = log2(word)
    lb_arr.map!{ |lb| (lb.couple[0] < lb.couple[1])? lb : lb.flip }
    lb_arr.sort!{|a, b| a.inspect_couple <=> b.inspect_couple }
    if lb_arr.kind_of?(LieBracket)
      lb_arr_smp = [lb_arr]
    else
      lb_arr_smp = []
      while (not lb_arr.empty?) do
        lb_arr_smp << lb_arr.shift
        k = lb_arr.index do |lb|
          lb.inspect_couple == lb_arr_smp.last.inspect_couple
        end
        unless k.nil? then
          lb_arr[k].coeff = lb_arr[k].coeff + lb_arr_smp.last.coeff
          lb_arr_smp.pop
        end
        lb_arr.delete_if{ |lb| lb.coeff == 0 }
      end
    end
    #---
    return lb_arr_smp
  end

  private
  def log2_calc(gen)
    result = nil
    @symp_pairs.each do |pair|
      result = pair.index(gen.to_char) # 0 or 1 or nil
      if not result.nil?
        binding.pry if gen.to_char == 'x'
        result = LieBracket.new(pair[0], pair[1])*((1/2r) - result.to_i)
      end
    end
    return (result.nil?) ? LieBracket.new : result
    # return case gen.to_char
    #        when 'a','B' then @base[0].dup
    #        when 'b','A' then @base[0]*(-1)
    #        when 's','T' then @base[1].dup
    #        when 't','S' then @base[1]*(-1)
    #        when 'x','Y' then @base[2].dup
    #        when 'y','X' then @base[2]*(-1)
    #        else Zero end
  end
end
#-----------------------------------------------

#==============
# End of File
#==============
