#
# StdMagnusExp_spec.rb
#
# Time-stamp: <2014-08-06 14:21:02 (ryosuke)>
#
require('spec_helper')

require('StdMagnusExp')

describe StdMagnusExp do
  
  Theta_std = StdMagnusExp.instance
  #---------------------------------
  it "is a Singleton class" do
    expect{ t=StdMagnusExp.new }.to raise_error(NoMethodError)
  end
  #---------------------------------
  
  #---------------------------------
  describe "#initialize" do
    it "sets @higher to be FormalSum::Zero" do
      expect(Theta_std.higher).to eq FormalSum::Zero
    end
    it "sets @mod_deg to be 4" do
      expect(Theta_std.mod_deg).to eq 4
    end
  end
  #---------------------------------
  
  #---------------------------------
  describe "#expand" do
    before :all do
      @gen_a = Generator.new('a')
      @gen_1 = Generator.new('1')
    end
    #  
    it "returns a FormalSum" do
      expect(Theta_std.expand(@gen_a)).to be_kind_of FormalSum
    end
    #
    context "for generators" do
      context "theta_std('a')" do
        subject { Theta_std.expand(@gen_a.dup).to_s }
        it { is_expected.to eq '1+a'}
      end
      #
      context "theta_std('A')" do
        subject { Theta_std.expand(@gen_a.invert!).to_s }
        it { is_expected.to eq '1-a+aa-aaa'}
      end
      #
      context "theta_std('1')" do
        subject { Theta_std.expand(@gen_1).to_s }
        it { is_expected.to eq '1'}
      end
    end
    #
    context "a word" do
      it "works properly" do
        deta=[%w[ab 1+a+b+ab],
              %w[aA 1],
              %w[abA 1+b+ab-ba-aba+baa],
              # 'abA' -> (1+a)(1+b)(1-a+aa-aaa)
              #          = (1+a+b+ab)(1-a+aa-aaa)
              #          = 1+(-a+a+b)+(aa+ab-aa-ba)+(-aaa+aaa+baa-aba)+{H}
              #          = 1+b+ab-ba-aba+baa+{H}
              %w[Bab 1+a+ab-ba-bab+bba],
              # 'Bab' -> (1-b+bb-bbb)(1+a)(1+b)
              #          = (1+a-b-ba+bb+bba-bbb+{H})(1+b) 
              #          = 1+a+ab-ba+bba-bab+{H}
              %w[abAB 1+ab-ba-aba-abb+baa+bab]
              # 'abAB' -> (1+a)(1+b)(1-a+aa-aaa)(1-b+bb-bbb)
              #          = (1+b+ab-ba-aba+baa+{H})(1-b+bb-bbb)
              #          = 1+(-b+b)+(-bb+bb+ab-ba)+(-bbb-aba+baa+bbb-abb+bab)+{H}
             ]
        deta.each do |arr|
          mw = Word.new(arr[0])
          expect(Theta_std.expand(mw).to_s).to eq arr[1]
        end
      end
    end
    #
    context "degree 1 part of the expansion of 'bAcaBC' (show)" do
      subject { Theta_std.expand(Word.new('bAcaBC')).homo_part(1).show }
      it { is_expected.to eq '(0)1'}
    end
    #
    context "degree 2 part of the expansion of 'bAcaB' (show)" do
      subject { Theta_std.expand(Word.new('bAcaB')).homo_part(2).show }
      it { is_expected.to eq '(-1)ac+(1)bc+(1)ca+(-1)cb'}
    end
    #
    context "degree 3 part of the expansion of 'cBDdaA' (show)" do
      subject { Theta_std.expand(Word.new('cBDdaA')).homo_part(3).show }
      it { is_expected.to eq '(-1)bbb+(1)cbb'}
    end
    #
    context "degree <= 2 part of the expansion of 'abAB' (sort.to_s)" do
      subject { Theta_std.expand(Word.new('abAB')).homo_part(0..2).sort.to_s }
      it { is_expected.to eq '1+ab-ba'}
    end
    #
    context "theta_std('bAcaB')-FromalSum('ca-ac')" do
      subject do
        f1 = Theta_std.expand(Word.new('bAcaB'))
        f2 = FormalSum.new('ca-ac')
        (f1-f2).homo_part(2).simplify.show
      end
      it { is_expected.to eq '(0)ac+(0)ca+(1)bc+(-1)cb'}
    end
    #
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
