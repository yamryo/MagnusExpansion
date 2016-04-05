#
# SympMagnusExp_spec.rb
#
# Time-stamp: <2016-04-05 10:05:07 (ryosuke)>
#
require('spec_helper')

require('SymplecticExp')


describe "SymplecticExp" do
  before(:all){ Theta_symp = SymplecticExp.instance }
  #---------------------------------
  it "is a Singleton class" do
    expect{ SymplecticExp.new }.to raise_error(NoMethodError)
  end
  #---------------------------------
  #---------------------------------
  describe "#initialize" do
    context "with specifying a symplectic basis" do
      subject { Theta_symp.symp_basis }
      it{ is_expected.to eq [%w[A B], %w[S T], %w[X Y]] }
    end
  end
  #---------------------------------
  #---------------------------------
  describe "#expand" do
    before :all do
      @gen_a = Generator.new('a')
    end
    #
    it "returns a FormalSum" do
      expect(Theta_symp.expand(@gen_a)).to be_kind_of FormalSum
    end
    #
    context "for generators" do
      let(:fs_a) { Theta_symp.expand(@gen_a) }
      #---
      context "theta_std('a')" do
        subject { fs_a.to_s }
        it do
          lab = LieBracket.new('A','B')
          lab_b = LieBracket.new(lab,'B')
          la_ab = LieBracket.new('A',lab)
          #--- t0 + t1 = 1+A
          t0 = FormalSum::One
          t1 = FormalSum.new('A')
          #--- t2 = (1/2)AA+(1/2)[A,B]
          t2 = FormalSum.new('1/2AA') + (lab*(1/2r)).expand
          #--- -(1/3)AAA+(1/2)(At2+t2A)+(1/12)[B,[B,A]]-(1/8)[A,[A,B]]
          t3 = FormalSum.new('-1/3AAA')
          t3 = t3 + (t1*t2 + t2*t1)*(1/2r)
          t3 = t3 + (lab_b*(1/12r)).expand+(la_ab*(-1/8r)).expand
          #---
          #is_expected.to eq (t0+t1+t2+t3).simplify.to_s
          is_expected.to eq (t0+t1+t2).simplify.to_s
        end
      end
      #
      context "theta_std('A')" do
        let(:fs_A) { Theta_symp.expand(@gen_a.invert!) }
        #subject { (fs_a*fs_A).simplify.homo_part(0..3).to_s }
        subject { (fs_a*fs_A).simplify.homo_part(0..2).to_s }
        it { is_expected.to eq '1'}
      end
      #
      context "theta_std('1')" do
        subject { Theta_symp.expand(Generator.new('1')).to_s }
        it { is_expected.to eq '1'}
      end
    end
    #
  #   context "a word" do
  #     let(:deta) do
  #       [{input: 'ab', output: '1+A+B+AB'},
  #        {input: 'aA', output: '1'},
  #        {input: 'abA', output: '1+B+AB-BA-ABA+BAA+ABAA-BAAA'},
  #        # 'abA' -> (1+A+B+AB)(1-A+AA-AAA+AAAA)
  #        #          = 1-A+AA-AAA+AAAA+A-AA+AAA-AAAA+B-BA+BAA-BAAA+AB-ABA+ABAA
  #        #          = 1+A-A+B+AA-AA+AB-BA+AAA-AAA-ABA+BAA+AAAA-AAAA+ABAA-BAAA
  #        #          = 1+B+AB-BA-ABA+BAA+ABAA-BAAA+{H}
  #        {input: 'Bab', output: '1+A+AB-BA-BAB+BBA+BBAB-BBBA'},
  #        # 'Bab' -> (1-B+BB-BBB+BBBB)(1+A+B+AB)
  #        #          = 1+A+B+AB-B-BA-BB-BAB+BB+BBA+BBB+BBAB-BBB-BBBA-BBBB+BBBB+{H}
  #        #          = 1+A+AB-BA-BAB+BBA+BBAB-BBBA+{H}
  #        {input: 'abAB', output: '1+AB-BA-ABA-ABB+BAA+BAB+ABAA+ABAB+ABBB-BAAA-BAAB-BABB'}
  #        # 'abAB' -> (1+B+AB-BA-ABA+BAA-BAAA+ABAA)(1-B+BB-BBB+BBBB)
  #        #           = 1-B+BB-BBB+BBBB+B-BB+BBB-BBBB+AB-ABB+ABBB-BA+BAB-BABB-ABA+ABAB+BAA-BAAB-BAAA+ABAA
  #        #           = 1+AB-BA-ABB-ABA+BAA+BAB+ABAA+ABAB+ABBB-BAAA-BAAB-BABB
  #       ]
  #     end
  #     it "works properly" do
  #       deta.each do |h|
  #         expect(Theta_symp.expand( Word.new(h[:input]) ).to_s).to eq h[:output]
  #       end
  #     end
  #   end
  #   #---
  #   context "degree 1 part of the expansion of 'bAcaBC' (show)" do
  #     let(:myfs) { Theta_symp.expand( Word.new('bAcaBC') ) }
  #     subject { myfs.homo_part(1).show }
  #     it { is_expected.to eq '(0)1'}
  #   end
  #   #---
  #   context "degree 2 part of the expansion of 'bAcaB' (show)" do
  #     let(:myfs) { Theta_symp.expand( Word.new('bAcaB') ) }
  #     subject { myfs.homo_part(2).show }
  #     it { is_expected.to eq '(-1)AC+(1)BC+(1)CA+(-1)CB'}
  #   end
  #   #---
  #   context "degree 3 part of the expansion of 'cBDdaA' (show)" do
  #     let(:myfs) { Theta_symp.expand( Word.new('cBDdaA') ) }
  #     subject { myfs.homo_part(3).show }
  #     it { is_expected.to eq '(-1)BBB+(1)CBB'}
  #   end
  #   #---
  #   context "degree <= 2 part of the expansion of 'abAB' (sort.to_s)" do
  #     let(:myfs) { Theta_symp.expand( Word.new('abAB') ) }
  #     subject { myfs.homo_part(0..2).sort.to_s }
  #     it { is_expected.to eq '1+AB-BA'}
  #   end
  #   #---
  #   context "theta_std('bAcaB')-FromalSum('CA-AC')" do
  #     let(:f1) { Theta_symp.expand(Word.new('bAcaB')) }
  #     let(:f2) { FormalSum.new('CA-AC') }
  #     subject { (f1-f2).homo_part(2).simplify.show }
  #     it { is_expected.to eq '(0)AC+(0)CA+(1)BC+(-1)CB' }
  #   end
  #   #---
  #   context "theta_std(a word contractible into '1')" do
  #     it "is '(1)1'" do
  #       ['aA', 'ZaAz', 'cBDdaAbC'].each do |str|
  #         expect(Theta_symp.expand(Word.new(str)).show).to eq '(1)1'
  #       end
  #     end
  #   end
  #   #
  end
  #---------------------------------
  #---------------------------------
   describe "#log2" do
    context "of a single generator" do
      before :all do
        @gen_a, @gen_b = Generator.new('a'), Generator.new('b')
        @gen_s, @gen_t = Generator.new('s'), Generator.new('t')
        @gen_x, @gen_y = Generator.new('x'), Generator.new('y')
      end
      xit "is a single LieBracket" do
        genarr = [@gen_a, @gen_b, @gen_s, @gen_t, @gen_x, @gen_y]
        expect( genarr.map{|g| Theta_symp.log2(g)} ).to all(be_kind_of LieBracket)
      end
    #
      it "is 1/2[X,Y] for x" do
        expect( Theta_symp.log2(@gen_a).to_s).to eq '1/2[A,B]'
        expect( Theta_symp.log2(@gen_s).to_s).to eq '1/2[S,T]'
        expect( Theta_symp.log2(@gen_x).to_s).to eq '1/2[X,Y]'
      end
      #
      it "is -1/2[X,Y] for y" do
        expect( Theta_symp.log2(@gen_b).to_s).to eq '-1/2[A,B]'
        expect( Theta_symp.log2(@gen_t).to_s).to eq '-1/2[S,T]'
        expect( Theta_symp.log2(@gen_y).to_s).to eq '-1/2[X,Y]'
      end
      #
      it "is -1/2[X,Y] for X" do
        expect( Theta_symp.log2(@gen_a.invert!).to_s).to eq '-1/2[A,B]'
        expect( Theta_symp.log2(@gen_s.invert!).to_s).to eq '-1/2[S,T]'
        expect( Theta_symp.log2(@gen_x.invert!).to_s).to eq '-1/2[X,Y]'
      end
      #
      it "is 1/2[X,Y] for Y" do
        expect( Theta_symp.log2(@gen_b.invert!).to_s).to eq '1/2[A,B]'
        expect( Theta_symp.log2(@gen_t.invert!).to_s).to eq '1/2[S,T]'
        expect( Theta_symp.log2(@gen_y.invert!).to_s).to eq '1/2[X,Y]'
      end
      #
    end
    #---
    context "of other generators" do
      before(:all){ @gen_1 = Generator.new('1') }
      it "are LieBracket::Zero" do
        expect(Theta_symp.log2(@gen_1)).to eq LieBracket::Zero
        expect(Theta_symp.log2(Generator.new('g'))).to eq LieBracket::Zero
      end
    end
    #---
    context "of a word" do
      it {expect(Theta_symp.log2(Word.new('aBxt'))).to be_kind_of Array and all(be_kind_of LieBracket)}
      #---
      it "works properly" do
        deta =[
               { word: 'ax',
                 img: "1/2[A,B]+1/2[A,X]+1/2[X,Y]",
                 smp: "1/2[A,B]+1/2[A,X]+1/2[X,Y]"
               },
               { word: 'yX',
                 img: "-1/2[X,Y]-1/2[Y,X]-1/2[X,Y]",
                 smp: "-1/2[X,Y]",},
               { word: 'aB',
                 img: "1/2[A,B]-1/2[A,B]+1/2[A,B]",
                 smp: "1/2[A,B]"},
                { word: 'abx',
                 img: "1/2[A,B]+1/2[A,B]+1/2[A,X]-1/2[A,B]+1/2[B,X]+1/2[X,Y]",
                 smp: "1/2[A,B]+1/2[A,X]+1/2[B,X]+1/2[X,Y]",},
               { word: 'aBx',
                 img: "1/2[A,B]-1/2[A,B]+1/2[A,X]+1/2[A,B]-1/2[B,X]+1/2[X,Y]",
                 smp: "1/2[A,B]+1/2[A,X]-1/2[B,X]+1/2[X,Y]"},
               { word: 'Ba',
                 img: "1/2[A,B]-1/2[B,A]+1/2[A,B]",
                 smp: "3/2[A,B]"},
               { word: 'aA',
                 img: "1/2[A,B]-1/2[A,B]",
                 smp: "0"},
               { word: 'aS',
                 img: "1/2[A,B]-1/2[A,S]-1/2[S,T]",
                 smp: "1/2[A,B]-1/2[A,S]-1/2[S,T]"},
               { word: 'Bab',
                 img: "1/2[A,B]-1/2[B,A]+1/2[A,B]+1/2[A,B]-1/2[A,B]",
                 smp: "3/2[A,B]"},
               { word: 'BaB',
                 img: "1/2[A,B]-1/2[B,A]+1/2[A,B]-1/2[A,B]+1/2[A,B]",
                 smp: "3/2[A,B]"},
               { word: 'stST',
                 img: "1/2[S,T]+1/2[S,T]-1/2[S,T]-1/2[S,T]-1/2[T,S]-1/2[S,T]+1/2[S,T]+1/2[S,T]",
                 smp: "[S,T]"},
               { word: 'tSb',
                 img: "-1/2[S,T]-1/2[T,S]+1/2[T,B]-1/2[S,T]-1/2[S,B]-1/2[A,B]",
                 smp: "-1/2[A,B]+1/2[B,S]-1/2[B,T]-1/2[S,T]"},
               { word: 'AaA',
                 img: "-1/2[A,B]+1/2[A,B]-1/2[A,B]",
                 smp: "-1/2[A,B]"}
              ]
        deta.each do |h|
          lb_arr = Theta_symp.log2(Word.new(h[:word]))
          str = lb_arr.map{|lb| lb.to_s }.join('+').gsub('+-','-')
          expect(str).to eq h[:img]
          #---
          lb_as = Theta_symp.log2_simplify(Word.new(h[:word]))
          str = lb_as.empty? ? "0" : lb_as.map{|lb| lb.to_s }.join('+').gsub('+-','-')
          expect(str).to eq h[:smp]
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
#     it { }
#   end
# end
# #---------------------------------

#End of File
