#
# FoxCalc_spec.rb
#
# Time-stamp: <2014-03-12 18:50:43 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('pry')
require('pry-byebug')

require('FoxCalc')

#---------------------------------
describe FoxCalculator, "when initializing" do
  before { @fc =  FoxCalculator }
  it { @fc.class.name.should == 'Module'}
end
#---------------------------------

describe FoxCalculator do

#---------------------------------
describe "#calc" do
  before :all do
    @fc = FoxCalculator
    @gen_a = Generator.new('a')
    @gen_b = Generator.new('b')
    @gen_g = Generator.new('g')
  end
  #  
  context "(del/del('a'))('a')" do
    subject { @fc[@gen_a].calc(@gen_a.dup).to_s }
    it { should == '1'}
  end
  #
  context "(del/del('a'))('A')" do
    subject { @fc[@gen_a].calc(@gen_a.inverse).to_s }
    it { should == '-A'}
  end
  #
  context "(del/del('a'))('b')" do
    subject { @fc[@gen_a].calc(@gen_b).to_s }
    it { should == '0'}
  end
  #
end
#---------------------------------

#---------------------------------
describe "#send" do
  before :all do
    @fc = FoxCalculator
    @gen_a = Generator.new('a')
  end
  #  
  context "(del/del('a'))('aBAc')" do
    # (del/del('a'))('aBAc') = 1+a(0+B(-A+A(0))) = 1-aBA
    subject { @fc[@gen_a].send(Word.new('aBAc')).to_s }
    it { should == '1-aBA'}
  end
  #
  context "(del/del('a'))('abAB')" do
    # (del/del('a'))('abAB') = 1+a(0+b(-A+A(0))) = 1+a0+ab(-A)+abA0 = 1-abA
    subject { @fc[@gen_a].send(Word.new('abAB')).to_s }
    it { should == '1-abA'}
  end
  #
  context "(del/del('a'))('Bab')" do
    # (del/del('a'))('Bab') = B(1+a(0)) = B
    subject { @fc[@gen_a].send(Word.new('Bab')).to_s }
    it { should == 'B'}
  end
  #
  context "(del/del('a'))('Aba')" do
    # (del/del('a'))('Aba') = -A+A(0+b(1)) = -A+b
    subject { @fc[@gen_a].send(Word.new('Aba')).to_s }
    it { should == '-A+Ab'}
  end
  #
  context "(del/del('a'))('bAcaBACBa')" do
    # (del/del('a'))('bAcaBACBa') = 0+b(-A+A(0+c(1+a(0+B(-A+A(0+C(0+B(1)..) 
    #                             = b(-A)+bAc1+bAcaB(-A)+bAcaBACB 
    #                             = -bA+bAc-bAcaBA+bAcaBACB
    subject { @fc[@gen_a].send(Word.new('bAcaBACBa')).to_s }
    it { should == '-bA+bAc-bAcaBA+bAcaBACB'}
  end
  #
  context "(del/del('a'))('bAcaBAcCaBa')" do
    # (del/del('a'))('bAcaBACBa') = 0+b(-A+A(0+c(1+a(0+B(0+B(1)..) = -bA+bAc+bAcaBB
    subject { @fc[@gen_a].send(Word.new('bAcaBAcCaBa')).to_s }
    it { should == '-bA+bAc+bAcaBB'}
  end
  #
  context "(del/del('a'))(a word contractible into '1')" do
    ['aA', 'ZaAz', 'cBDdaAbC', 'cBDdaA-3(b+C)'].each do |str|
      it { @fc[@gen_a].send(Word.new(str)).should == '0' }
    end
  end
  #
end
#---------------------------------

# #---------------------------------
# describe FoxCalculator, "" do
#   context "" do
#     int { }
#   end
# end
# #---------------------------------

end
#End of File
