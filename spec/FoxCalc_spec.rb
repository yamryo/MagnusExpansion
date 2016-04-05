#
# FoxCalc_spec.rb
#
# Time-stamp: <2016-04-04 11:31:40 (ryosuke)>
#
require('spec_helper')

require('FoxCalc')

describe FoxCalculator do
  before :all do
    @fc = FoxCalculator
    @gen_a = Generator.new('a')
  end

  #---------------------------------
  describe "when initialized" do
    it "is a Module" do
      expect( @fc ).to be_a_kind_of Module
      expect{ FoxCalculator.new }.to raise_error NoMethodError
    end
  end
  #---------------------------------
  #---------------------------------
  describe "#derivative" do
    before :all do
      @gen_b = Generator.new('b')
      @gen_g = Generator.new('g')
    end
    #
    context "without setting @generator properly" do
      it "raises ArgumentError" do
        expect{ @fc.derivative(@gen_a) }.to raise_error(ArgumentError)
        expect{ @fc[1].derivative(@gen_a) }.to raise_error(ArgumentError)
        expect{ @fc[Generator.new('A')].derivative(@gen_a) }.to raise_error(ArgumentError, "You should set a Generator which is not inverse." )
      end
    end
    #
    context "with an object which is neither a Generator nor a Word" do
      subject { @fc[@gen_a] }
      it "raises the InvalidArgument Error" do
        expect{ subject.derivative('ab') }.to raise_error(ArgumentError)
        expect{ subject.derivative(3) }.to raise_error(ArgumentError)
        expect{ subject.derivative(:key) }.to raise_error(ArgumentError)
        expect{ subject.derivative([4]) }.to raise_error(ArgumentError)
      end
    end
    #
    context "with a Generator" do
      it "works properly" do
        deta = [%w[a 1], %w[A, -A], %w[b, 0], %w[B, 0], %w[1, 0]]
        deta.each do |arr|
          gen = Generator.new(arr[0])
          fs = @fc[@gen_a].derivative(gen)
          expect( fs ).to be_kind_of FormalSum
          expect( fs.to_s ).to eq arr[1]
        end
      end
    end
    #
    context "with a word" do
      it "works properly" do
        deta = [{input: 'aa', output: '1+a'},
                # 'aa' -> 1+a(1) = 1+a
                {input: 'aBAc', output: '1-aBA'},
                # 'aBAc' -> 1+a(0+B(-A+A(0))) = 1-aBA
                {input: 'abAB', output: '1-abA'},
                # 'abAB' -> 1+a(0+b(-A+A(0))) = 1+a0+ab(-A)+abA0 = 1-abA
                {input: 'Bab', output: 'B'},
                # 'Bab'  -> B(1+a(0)) = B
                {input: 'Aba', output: '-A+Ab'},
                # 'Aba'  -> -A+A(0+b(1)) = -A+Ab
                {input: 'bAcaBACBa', output: '-bA+bAc-bAcaBA+bAcaBACB'},
                # 'bAcaBACBa' -> 0+b(-A+A(0+c(1+a(0+B(-A+A(0+C(0+B(1)..)
                #                = b(-A)+bAc1+bAcaB(-A)+bAcaBACB
                #                = -bA+bAc-bAcaBA+bAcaBACB
                {input: 'bAcaBAcCaBa', output: '-bA+bAc+bAcaBB'},
                # 'bAcaBAcCaBa' -> 0+b(-A+A(0+c(1+a(0+B(0+B(1)..)
                #                  = -bA+bAc+bAcaBB
                ]
        deta.each do |h|
          word = Word.new(h[:input])
          fs = @fc[@gen_a].derivative(word)
          expect( fs ).to be_kind_of FormalSum
          expect( fs.to_s ).to eq h[:output]
        end
      end
    end
    context "a word which is contractible into '1'" do
      it "to zero" do
        %w[aA Aa ZaAz cBDdaAbC].each do |str|
          fs = @fc[@gen_a].derivative(Word.new(str))
          expect( fs.to_s ).to eq '0'
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
