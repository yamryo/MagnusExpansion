#
# StdMagnusExp_spec.rb
#
# Time-stamp: <2016-04-04 02:06:23 (ryosuke)>
#
require('spec_helper')

require('StdMagnusExp')

describe StdMagnusExp do

  Theta_std = StdMagnusExp.instance
  #---------------------------------
  it "is a Singleton class" do
    expect{ StdMagnusExp.new }.to raise_error(NoMethodError)
  end
  #---------------------------------

  #---------------------------------
  describe "#initialize" do
    # it "sets @higher to be FormalSum::Zero" do
    #   expect(Theta_std.higher).to eq FormalSum::Zero
    # end
    # it "sets @mod_deg to be 4" do
    #   expect(Theta_std.mod_deg).to eq 4
    # end
  end
  #---------------------------------

  #---------------------------------
  describe "#expand" do
    before :all do
      @gen_a = Generator.new('a')
    end
    #
    it "returns a FormalSum" do
      expect(Theta_std.expand(@gen_a)).to be_kind_of FormalSum
    end
    #
    context "for generators" do
      let(:fs_a) { Theta_std.expand(@gen_a) }
      #---
      context "theta_std('a')" do
        subject { fs_a.to_s }
        it { is_expected.to eq '1+A'}
      end
      #
      context "theta_std('A')" do
        let(:fs_A) { Theta_std.expand(@gen_a.invert!) }
        subject { (fs_a*fs_A).simplify.homo_part(0..4).to_s }
        it { is_expected.to eq '1'}
      end
      #
      context "theta_std('1')" do
        subject { Theta_std.expand(Generator.new('1')).to_s }
        it { is_expected.to eq '1'}
      end
    end
    #
    context "a word" do
      let(:deta) do
        [{input: 'ab', output: '1+A+B+AB'},
         {input: 'aA', output: '1'},
         {input: 'abA', output: '1+B+AB-BA-ABA+BAA+ABAA-BAAA'},
         # 'abA' -> (1+A+B+AB)(1-A+AA-AAA+AAAA)
         #          = 1-A+AA-AAA+AAAA+A-AA+AAA-AAAA+B-BA+BAA-BAAA+AB-ABA+ABAA
         #          = 1+A-A+B+AA-AA+AB-BA+AAA-AAA-ABA+BAA+AAAA-AAAA+ABAA-BAAA
         #          = 1+B+AB-BA-ABA+BAA+ABAA-BAAA+{H}
         {input: 'Bab', output: '1+A+AB-BA-BAB+BBA+BBAB-BBBA'},
         # 'Bab' -> (1-B+BB-BBB+BBBB)(1+A+B+AB)
         #          = 1+A+B+AB-B-BA-BB-BAB+BB+BBA+BBB+BBAB-BBB-BBBA-BBBB+BBBB+{H}
         #          = 1+A+AB-BA-BAB+BBA+BBAB-BBBA+{H}
         {input: 'abAB', output: '1+AB-BA-ABA-ABB+BAA+BAB+ABAA+ABAB+ABBB-BAAA-BAAB-BABB'}
         # 'abAB' -> (1+B+AB-BA-ABA+BAA-BAAA+ABAA)(1-B+BB-BBB+BBBB)
         #           = 1-B+BB-BBB+BBBB+B-BB+BBB-BBBB+AB-ABB+ABBB-BA+BAB-BABB-ABA+ABAB+BAA-BAAB-BAAA+ABAA
         #           = 1+AB-BA-ABB-ABA+BAA+BAB+ABAA+ABAB+ABBB-BAAA-BAAB-BABB
        ]
      end
      it "works properly" do
        deta.each do |h|
          expect(Theta_std.expand( Word.new(h[:input]) ).to_s).to eq h[:output]
        end
      end
    end
    #---
    context "degree 1 part of the expansion of 'bAcaBC' (show)" do
      let(:myfs) { Theta_std.expand( Word.new('bAcaBC') ) }
      subject { myfs.homo_part(1).show }
      it { is_expected.to eq '(0)1'}
    end
    #---
    context "degree 2 part of the expansion of 'bAcaB' (show)" do
      let(:myfs) { Theta_std.expand( Word.new('bAcaB') ) }
      subject { myfs.homo_part(2).show }
      it { is_expected.to eq '(-1)AC+(1)BC+(1)CA+(-1)CB'}
    end
    #---
    context "degree 3 part of the expansion of 'cBDdaA' (show)" do
      let(:myfs) { Theta_std.expand( Word.new('cBDdaA') ) }
      subject { myfs.homo_part(3).show }
      it { is_expected.to eq '(-1)BBB+(1)CBB'}
    end
    #---
    context "degree <= 2 part of the expansion of 'abAB' (sort.to_s)" do
      let(:myfs) { Theta_std.expand( Word.new('abAB') ) }
      subject { myfs.homo_part(0..2).sort.to_s }
      it { is_expected.to eq '1+AB-BA'}
    end
    #---
    context "theta_std('bAcaB')-FromalSum('CA-AC')" do
      let(:f1) { Theta_std.expand(Word.new('bAcaB')) }
      let(:f2) { FormalSum.new('CA-AC') }
      subject { (f1-f2).homo_part(2).simplify.show }
      it { is_expected.to eq '(0)AC+(0)CA+(1)BC+(-1)CB' }
    end
    #---
    context "theta_std(a word contractible into '1')" do
      it "is '(1)1'" do
        ['aA', 'ZaAz', 'cBDdaAbC'].each do |str|
          expect(Theta_std.expand(Word.new(str)).show).to eq '(1)1'
        end
      end
    end
    #
  end
  #---------------------------------
end

  # #---------------------------------
  # describe "" do
  #   context "" do
  #     int { }
  #   end
  # end
  # #---------------------------------

#End of File
