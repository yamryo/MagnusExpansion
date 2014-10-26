#
# FoxCalc_spec.rb
#
# Time-stamp: <2014-08-07 14:58:12 (ryosuke)>
#
require('spec_helper')

require('FoxCalc')

describe FoxCalculator do
  before :all do
    @fc = FoxCalculator
    @gen_a = Generator.new('a')
  end
  
  #---------------------------------
  it "is a Module" do
    expect(@fc).to be_a_kind_of Module
  end
  #---------------------------------

  #---------------------------------
  describe "#calc" do
    it "is a private method" do
      expect{ @fc.calc(@gen_a).to raise_error(NoMethodError) }
    end
  end
  #---------------------------------

  #---------------------------------
  describe "#send" do
    before :all do
      @gen_b = Generator.new('b')
      @gen_g = Generator.new('g')
    end
    #  
    context "with an object which is not either a Generator nor a Word" do
      subject { @fc[@gen_a] }
      it "raises the InvalidArgument Error" do
        expect{ subject.send('ab') }.to raise_error(ArgumentError)
        expect{ subject.send(3) }.to raise_error(ArgumentError)
        expect{ subject.send(:key) }.to raise_error(ArgumentError)
        expect{ subject.send([4]) }.to raise_error(ArgumentError)
      end
    end
    #  
    context "with a Generator" do
      it "works properly" do
        deta = [%w[a 1], %w[A, -A], %w[b, 0], %w[B, 0], %w[1, 0]]
        deta.each do |arr|
          gen = Generator.new(arr[0])
          expect( @fc[@gen_a].send(gen).to_s ).to eq arr[1]
        end
      end
    end
    #
    context "with a word" do
      it "works properly" do
        deta = [%w[aa, 1+a],   # 'aa' -> 1+a(1) = 1+a
                %w[aBAc, 1-aBA], # 'aBAc' -> 1+a(0+B(-A+A(0))) = 1-aBA
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
        %w[aA Aa ZaAz cBDdaAbC].each do |str|
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
