#
# GrouplikeExp_spec.rb
#
# Time-stamp: <2014-10-26 15:52:31 (ryosuke)>
#
require('spec_helper')

require('GrouplikeExp')
#require('LieBracket')
#require('FormalSum')

describe "GrouplikeExp" do
  Theta_gl = GrouplikeExp.instance

  #---------------------------------
  describe "#log2" do
    context "of a single generator" do
      before :all do
        @gen_1 = Generator.new('1')
        @gen_a, @gen_b = Generator.new('a'), Generator.new('b')
        @gen_s, @gen_t = Generator.new('s'), Generator.new('t')
        @gen_x, @gen_y = Generator.new('x'), Generator.new('y')
      end
      it "is a single LieBracket" do
        genarr = [@gen_a, @gen_b, @gen_s, @gen_t, @gen_x, @gen_y]
        expect( genarr.map{|g| Theta_gl.log2(g)} ).to all(be_kind_of LieBracket)
      end
    #
      it "is 1/2[|x|,|y|] for x" do
        expect( Theta_gl.log2(@gen_a).to_s).to eq '1/2[|a|,|b|]'
        expect( Theta_gl.log2(@gen_s).to_s).to eq '1/2[|s|,|t|]'
        expect( Theta_gl.log2(@gen_x).to_s).to eq '1/2[|x|,|y|]'
      end
      #
      it "is -1/2[|x|,|y|] for y" do
        expect( Theta_gl.log2(@gen_b).to_s).to eq '-1/2[|a|,|b|]'
        expect( Theta_gl.log2(@gen_t).to_s).to eq '-1/2[|s|,|t|]'
        expect( Theta_gl.log2(@gen_y).to_s).to eq '-1/2[|x|,|y|]'
      end
      #
      it "is -1/2[|x|,|y|] for X" do
        expect( Theta_gl.log2(@gen_a.invert!).to_s).to eq '-1/2[|a|,|b|]'
        expect( Theta_gl.log2(@gen_s.invert!).to_s).to eq '-1/2[|s|,|t|]'
        expect( Theta_gl.log2(@gen_x.invert!).to_s).to eq '-1/2[|x|,|y|]'
      end
      #
      it "is 1/2[|x|,|y|] for Y" do
        expect( Theta_gl.log2(@gen_b.invert!).to_s).to eq '1/2[|a|,|b|]'
        expect( Theta_gl.log2(@gen_t.invert!).to_s).to eq '1/2[|s|,|t|]'
        expect( Theta_gl.log2(@gen_y.invert!).to_s).to eq '1/2[|x|,|y|]'
      end
      #
    end
    #----------------------------------------------------
    context "of other generators" do
      it "are FormalSum::Zero" do
        expect(Theta_gl.log2(@gen_1)).to eq FormalSum::Zero
        expect(Theta_gl.log2(Generator.new('g'))).to eq FormalSum::Zero
      end
    end
    #----------------------------------------------------
    context "of a word" do
      subject{ Theta_gl.log2(Word.new('aBxt')) }
      it {is_expected.to be_kind_of Array and all(be_kind_of LieBracket)}
      #---
      it "works properly" do
        deta =[
               { word: 'ax',
                 img: "1/2[|a|,|b|]+1/2[|a|,|x|]+1/2[|x|,|y|]",
                 smp: "1/2[|a|,|b|]+1/2[|a|,|x|]+1/2[|x|,|y|]"
               },
               { word: 'yX',
                 img: "-1/2[|x|,|y|]+1/2[|x|,|y|]-1/2[|x|,|y|]",
                 smp: "-1/2[|x|,|y|]",},
               { word: 'aB',
                 img: "1/2[|a|,|b|]-1/2[|a|,|b|]+1/2[|a|,|b|]",
                 smp: "1/2[|a|,|b|]"},
                { word: 'abx',
                 img: "1/2[|a|,|b|]+1/2[|a|,|b|]-1/2[|a|,|b|]+1/2[|a|,|x|]+1/2[|b|,|x|]+1/2[|x|,|y|]",
                 smp: "1/2[|a|,|b|]+1/2[|a|,|x|]+1/2[|b|,|x|]+1/2[|x|,|y|]",},
               { word: 'aBx',
                 #=log2(a)+1/2[|a|,|Bx|]+log2(Bx)
                 #=log2(a)+1/2[|a|,|Bx|]+log2(B)+1/2[|B|,|x|]+log2(x)
                 #=1/2[|a|,|b|]+1/2[|a|,|Bx|]+1/2[|a|,|b|]-1/2[|b|,|x|]+1/2[|x|,|y|]
                 img: "1/2[|a|,|b|]-1/2[|a|,|b|]+1/2[|a|,|b|]+1/2[|a|,|x|]-1/2[|b|,|x|]+1/2[|x|,|y|]",
                 smp: "1/2[|a|,|b|]+1/2[|a|,|x|]-1/2[|b|,|x|]+1/2[|x|,|y|]"},
               { word: 'Ba',
                 img: "1/2[|a|,|b|]+1/2[|a|,|b|]+1/2[|a|,|b|]",
                 smp: "3/2[|a|,|b|]"},
               { word: 'aA',
                 img: "1/2[|a|,|b|]-1/2[|a|,|b|]",
                 smp: "0"},
               { word: 'Bab',
                 img: "1/2[|a|,|b|]+1/2[|a|,|b|]+1/2[|a|,|b|]+1/2[|a|,|b|]-1/2[|a|,|b|]",
                 smp: "3/2[|a|,|b|]"},
               { word: 'BaB',
                 img: "1/2[|a|,|b|]+1/2[|a|,|b|]+1/2[|a|,|b|]-1/2[|a|,|b|]+1/2[|a|,|b|]",
                 smp: "3/2[|a|,|b|]"},
               { word: 'abAB',
                 img: "1/2[|a|,|b|]+1/2[|a|,|b|]-1/2[|a|,|b|]-1/2[|a|,|b|]+1/2[|a|,|b|]-1/2[|a|,|b|]+1/2[|a|,|b|]+1/2[|a|,|b|]",
                 smp: "[|a|,|b|]"},
              ]
        deta.each do |h|
          lb_arr = Theta_gl.log2(Word.new(h[:word]))
          str = lb_arr.map{|lb| lb.to_s }.join('+').gsub('+-','-')
          expect(str).to eq h[:img]
          #---
          lb_as = Theta_gl.log2_simplify(Word.new(h[:word]))
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
