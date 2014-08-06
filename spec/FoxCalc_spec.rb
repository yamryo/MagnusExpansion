#
# FoxCalc_spec.rb
#
# Time-stamp: <2014-08-06 14:20:34 (ryosuke)>
#
require('spec_helper')

require('FoxCalc')

describe FoxCalculator do
  before(:all){ @fc = FoxCalculator }
  
  #---------------------------------
  it "is a Module" do
    expect(@fc).to be_a_kind_of Module
  end
  #---------------------------------

  #---------------------------------
  describe "#calc" do
    before :all do
      @gen_a = Generator.new('a')
      @gen_b = Generator.new('b')
      @gen_g = Generator.new('g')
    end
    #  
    context "(del/del('a'))('a')" do
      subject { @fc[@gen_a].calc(@gen_a.dup).to_s }
      it { is_expected.to eq '1'}
    end
    #
    context "(del/del('a'))('A')" do
      subject { @fc[@gen_a].calc(@gen_a.invert!).to_s }
      it { is_expected.to eq '-A'}
    end
    #
    context "(del/del('a'))('b')" do
      subject { @fc[@gen_a].calc(@gen_b).to_s }
      it { is_expected.to eq '0'}
    end
    #
  end
  #---------------------------------

  #---------------------------------
  describe "#send" do
    before(:all){ @gen_a = Generator.new('a') }
    #  
    context "a word" do
      it "to its expansion" do
        deta = [%w[aBAc, 1-aBA], # 'aBAc' -> 1+a(0+B(-A+A(0))) = 1-aBA
                %w[abAB, 1-abA], # 'abAB' -> 1+a(0+b(-A+A(0))) = 1+a0+ab(-A)+abA0 = 1-abA
                %w[Bab, B],      # 'Bab'  -> B(1+a(0)) = B
                %w[Aba, -A+Ab],   # 'Aba'  -> -A+A(0+b(1)) = -A+Ab
                %w[bAcaBACBa, -bA+bAc-bAcaBA+bAcaBACB],
                # 'bAcaBACBa' -> 0+b(-A+A(0+c(1+a(0+B(-A+A(0+C(0+B(1)..) 
                #                = b(-A)+bAc1+bAcaB(-A)+bAcaBACB 
                #                = -bA+bAc-bAcaBA+bAcaBACB
                %w[bAcaBAcCaBa, -bA+bAc+bAcaBB]
                # 'bAcaBAcCaBa' -> 0+b(-A+A(0+c(1+a(0+B(0+B(1)..) = -bA+bAc+bAcaBB
                ]
        deta.each do |arr|
          expect(@fc[@gen_a].send(Word.new(arr[0])).to_s).to eq arr[1]
        end
      end
    end
    context "a word which is contractible into '1'" do
      it "to zero" do
        %w[aA ZaAz cBDdaAbC cBDdaA-3(b+C)].each do |str|
          expect(@fc[@gen_a].send(Word.new(str))).to eq '0'
        end
      end
    #
    end
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
