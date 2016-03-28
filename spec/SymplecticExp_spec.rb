#
# SympMagnusExp_spec.rb
#
# Time-stamp: <2016-03-28 18:16:17 (ryosuke)>
#
require('spec_helper')

require('SymplecticExp')


describe "SymplecticExp" do
  #---------------------------------
  # describe "#initialize" do
  #   context "with specifying a symplectic generators" do
  #     SymplecticExp([%w[a b], %w[s t] %w[x y]])
  #   end
  # end
  #
  #---------------------------------
  describe "#log2" do
    before(:all){ Theta_symp = SymplecticExp.instance }
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
    #----------------------------------------------------
    context "of other generators" do
      before(:all){ @gen_1 = Generator.new('1') }
      it "are LieBracket::Zero" do
        expect(Theta_symp.log2(@gen_1)).to eq LieBracket::Zero
        expect(Theta_symp.log2(Generator.new('g'))).to eq LieBracket::Zero
      end
    end
    #----------------------------------------------------
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
