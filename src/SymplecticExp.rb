#
# SymplecticExp.rb
#
# Time-stamp: <2016-04-05 13:07:17 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../lib/GLA/src/')

require('FormalSum')
require('LieBracket')
require('MagnusExp')
require('singleton')

#-----------------------------------------------
class SymplecticExp
  include Expander, Singleton

  DefaultSympBasis = [%w[A B], %w[S T], %w[X Y]]

  def initialize(basis=DefaultSympBasis)
    @symp_basis = basis
    # @lb_basis = @symp_basis.map{ |pr| LieBracket.new(pr[0], pr[1])*(1/2r) }
  end
  attr_reader :symp_basis

  def expand(word)
    super(word).homo_part(0..2)
  end
  #---
  def higher(gen)
    second_deg(gen) #+ third_deg(gen)
  end
  #---
  def second_deg(gen)
    fsa = abelianize(gen)
    (fsa*fsa)*(1/2r) + log2_calc(gen).to_fs
  end
  # def third_deg(gen)
  #   fsa, fsb = abelianize(gen), abelianize_partner(gen)
  #   ell3 = LieBracket.new( fsa*(-1/4r) + fsb*(-1/6r), log2_calc(gen) )
  #   myfs = second_deg(gen)
  #   ell3 #- (fsa*fsa*fsa)*(1/3r) #+ (fsa*myfs+myfs*fsa)*(1/2r)
  # end

  #---
  def log2(word)
    lb_arr = []
    #binding.pry if word == Generator.new('1')
    if word.is_a? Generator then
      return log2_calc(word)
    else
      raise ArgumentError, 'Wrong arguments' unless word.is_a?(Word) || word.is_a?(String)
      word = Word.new(word) unless word.is_a?(Word)
      if word.length == 1
        lb_arr << self.log2(Generator.new(word))
      else
        first_gen = word.gen_at(0) # the first letter
        word.slice!(0,1) # the rest of the word
        #binding.pry
        #---
        lb_arr << self.log2(first_gen)
        #---
        wa = [first_gen.letter.upcase,'0']
        word.each_gen do |g|
          unless first_gen =~ g then
            wa[1] = g.letter.upcase
            cf = (1/2r)*((first_gen.inverse?) ? -1 : 1)*((g.inverse?) ? -1 : 1)
            lb_arr << LieBracket.new(wa[0], wa[1])*cf
          end
        end
        #---
        lb_arr << self.log2(word)
      end
      #---
      return lb_arr.flatten
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
    return (lb_arr_smp.empty?) ? [FormalSum::Zero] : lb_arr_smp
  end

  private
  def abelianize_partner(gen)
    partner = FormalSum::Zero
    @symp_basis.each do |pair|
      idx = pair.index(gen.letter.upcase) # 0 or 1 or nil
      unless idx.nil?
        partner = FormalSum.new(pair[ (idx + 1)%2 ])
        #*(gen.inverse? ? -1 : 1)
      end
    end
    return partner
  end

  def log2_calc(gen)
    result = LieBracket::Zero
    @symp_basis.each do |pair|
      idx = pair.index(gen.letter.upcase) # 0 or 1 or nil
      unless idx.nil?
        sgn = (-1)**(idx + ((gen.inverse?) ? 1 : 0 ))
        #binding.pry
        result = LieBracket.new(pair[0], pair[1]) * (1/2r) * sgn
      end
    end
    return result
  end
end
#-----------------------------------------------

#==============
# End of File
#==============
