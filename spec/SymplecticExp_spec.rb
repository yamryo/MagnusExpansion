#
# SympMagnusExp_spec.rb
#
# Time-stamp: <2016-02-29 12:47:12 (ryosuke)>
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
      it "is a single LieBracket" do
        genarr = [@gen_a, @gen_b, @gen_s, @gen_t, @gen_x, @gen_y]
        expect( genarr.map{|g| Theta_symp.log2(g)} ).to all(be_kind_of LieBracket)
      end
    #
      it "is 1/2[x,y] for x" do
        expect( Theta_symp.log2(@gen_a).to_s).to eq '1/2[a,b]'
        expect( Theta_symp.log2(@gen_s).to_s).to eq '1/2[s,t]'
        expect( Theta_symp.log2(@gen_x).to_s).to eq '1/2[x,y]'
      end
      #
      it "is -1/2[x,y] for y" do
        expect( Theta_symp.log2(@gen_b).to_s).to eq '-1/2[a,b]'
        expect( Theta_symp.log2(@gen_t).to_s).to eq '-1/2[s,t]'
        expect( Theta_symp.log2(@gen_y).to_s).to eq '-1/2[x,y]'
      end
      #
      it "is -1/2[x,y] for X" do
        expect( Theta_symp.log2(@gen_a.invert!).to_s).to eq '-1/2[a,b]'
        expect( Theta_symp.log2(@gen_s.invert!).to_s).to eq '-1/2[s,t]'
        expect( Theta_symp.log2(@gen_x.invert!).to_s).to eq '-1/2[x,y]'
      end
      #
      it "is 1/2[x,y] for Y" do
        expect( Theta_symp.log2(@gen_b.invert!).to_s).to eq '1/2[a,b]'
        expect( Theta_symp.log2(@gen_t.invert!).to_s).to eq '1/2[s,t]'
        expect( Theta_symp.log2(@gen_y.invert!).to_s).to eq '1/2[x,y]'
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
                 img: "1/2[a,b]+1/2[a,x]+1/2[x,y]",
                 smp: "1/2[a,b]+1/2[a,x]+1/2[x,y]"
               },
               { word: 'yX',
                 img: "-1/2[x,y]-1/2[y,x]-1/2[x,y]",
                 smp: "-1/2[x,y]",},
               { word: 'aB',
                 img: "1/2[a,b]-1/2[a,b]+1/2[a,b]",
                 smp: "1/2[a,b]"},
                { word: 'abx',
                 img: "1/2[a,b]+1/2[a,b]+1/2[a,x]-1/2[a,b]+1/2[b,x]+1/2[x,y]",
                 smp: "1/2[a,b]+1/2[a,x]+1/2[b,x]+1/2[x,y]",},
               { word: 'aBx',
                 img: "1/2[a,b]-1/2[a,b]+1/2[a,x]+1/2[a,b]-1/2[b,x]+1/2[x,y]",
                 smp: "1/2[a,b]+1/2[a,x]-1/2[b,x]+1/2[x,y]"},
               { word: 'Ba',
                 img: "1/2[a,b]-1/2[b,a]+1/2[a,b]",
                 smp: "3/2[a,b]"},
               { word: 'aA',
                 img: "1/2[a,b]-1/2[a,b]",
                 smp: "0"},
               { word: 'aS',
                 img: "1/2[a,b]-1/2[a,s]-1/2[s,t]",
                 smp: "1/2[a,b]-1/2[a,s]-1/2[s,t]"},
               { word: 'Bab',
                 img: "1/2[a,b]-1/2[b,a]+1/2[a,b]+1/2[a,b]-1/2[a,b]",
                 smp: "3/2[a,b]"},
               { word: 'BaB',
                 img: "1/2[a,b]-1/2[b,a]+1/2[a,b]-1/2[a,b]+1/2[a,b]",
                 smp: "3/2[a,b]"},
               { word: 'stST',
                 img: "1/2[s,t]+1/2[s,t]-1/2[s,t]-1/2[s,t]-1/2[t,s]-1/2[s,t]+1/2[s,t]+1/2[s,t]",
                 smp: "[s,t]"},
               { word: 'tSb',
                 img: "-1/2[s,t]-1/2[t,s]+1/2[t,b]-1/2[s,t]-1/2[s,b]-1/2[a,b]",
                 smp: "-1/2[a,b]+1/2[b,s]-1/2[b,t]-1/2[s,t]"},
               { word: 'AaA',
                 img: "-1/2[a,b]+1/2[a,b]-1/2[a,b]",
                 smp: "-1/2[a,b]"}
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
