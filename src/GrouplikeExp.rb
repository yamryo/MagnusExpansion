#
# GrouplikeExp.rb
#
# Time-stamp: <2014-11-04 20:39:29 (kaigishitsu)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../lib/GLA/src/')

require('FormalSum')
require('LieBracket')
require('MagnusExp')
require('singleton')

#-----------------------------------------------
class GrouplikeExp
  include Expander, Singleton
  
  def initialize(m=3)
    @mod_deg = m
    @lb1 = LieBracket.new('|a|','|b|')*(1/2r)
    @lb2 = LieBracket.new('|s|','|t|')*(1/2r)
    @lb3 = LieBracket.new('|x|','|y|')*(1/2r)
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
      #---
      if word.length == 1
        lb_arr << log2_calc(Generator.new(word))
      else
        first_gen = word.gen_at(0)
        rest_of_word = (Word.new(word.gen_at(0).invert!.to_char)*word).contract
        lb_arr << self.log2(first_gen)
        #---
        wa = ['|'+first_gen.to_char.downcase+'|','0']
        #binding.pry if rest_of_word == "Sb"
        rest_of_word.each_gen do |g|
          unless first_gen =~ g then
            wa[1] = '|'+g.to_char.downcase+'|'
            cf = (1/2r)*((first_gen.inverse?) ? -1 : 1)*((g.inverse?) ? -1 : 1)
            lb_arr << LieBracket.new(wa[0], wa[1])*cf
          end
        end
        #---
        lb_arr << self.log2(rest_of_word)
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
    binding.pry if @lb1.coeff == (3/2r)
    return case gen.to_char
           when 'a','B' then @lb1.dup
           when 'b','A' then @lb1*(-1)
           when 's','T' then @lb2.dup
           when 't','S' then @lb2*(-1)
           when 'x','Y' then @lb3.dup
           when 'y','X' then @lb3*(-1)
           else Zero end
  end
end
#-----------------------------------------------

#==============
# End of File
#==============
