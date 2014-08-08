#
# GrouplikeExp_spec.rb
#
# Time-stamp: <2014-08-08 15:58:57 (ryosuke)>
#
require('spec_helper')

require('GrouplikeExp')
#require('LieBracket')
#require('FormalSum')

describe "GrouplikeExp" do
  Theta_gl = GrouplikeExp.instance

  #---------------------------------
  describe "#log2" do
    before :all do
      @gen_1 = Generator.new('1')
      @gen_a, @gen_b = Generator.new('a'), Generator.new('b')
      @gen_s, @gen_t = Generator.new('s'), Generator.new('t')
      @gen_x, @gen_y = Generator.new('x'), Generator.new('y')
    end
    #  
    #  context "return Zero for 1" do
    #    it { expect(Theta_gl.log2(@gen_1)).to eq Zero }
    #  end
    #
    context "of generators a,b,s,t,x,y " do
      it "are LieBrackets" do
        expect(Theta_gl.log2(@gen_x)).to be_kind_of LieBracket
      end
    #
      it "is a [x,y] for x" do
        expect( Theta_gl.log2(@gen_a).to_s).to eq '1/2[a,b]'
        expect( Theta_gl.log2(@gen_s).to_s).to eq '1/2[s,t]'
        expect( Theta_gl.log2(@gen_x).to_s).to eq '1/2[x,y]'
      end
      #
      it "is a -[x,y] for y" do
        expect( Theta_gl.log2(@gen_b).to_s).to eq '-1/2[a,b]'
        expect( Theta_gl.log2(@gen_t).to_s).to eq '-1/2[s,t]'
        expect( Theta_gl.log2(@gen_y).to_s).to eq '-1/2[x,y]'
      end
      #
      it "is a -[x,y] for X" do
        expect( Theta_gl.log2(@gen_a.invert!).to_s).to eq '-1/2[a,b]'
        expect( Theta_gl.log2(@gen_s.invert!).to_s).to eq '-1/2[s,t]'
        expect( Theta_gl.log2(@gen_x.invert!).to_s).to eq '-1/2[x,y]'
      end
      #
      it "is a [x,y] for Y" do
        expect( Theta_gl.log2(@gen_b.invert!).to_s).to eq '1/2[a,b]'
        expect( Theta_gl.log2(@gen_t.invert!).to_s).to eq '1/2[s,t]'
        expect( Theta_gl.log2(@gen_y.invert!).to_s).to eq '1/2[x,y]'
      end
      #
    end
    #
    context "of other generators" do
      it "are FormalSum::Zero" do
        expect(Theta_gl.log2(@gen_1)).to eq FormalSum::Zero
        expect(Theta_gl.log2(Generator.new('g'))).to eq FormalSum::Zero
      end
    end
    #
    context "of a word" do
      before(:all){ @lb_arr = Theta_gl.log2(@word_ax) } 
      #
      it "is an array of LieBracket" do
        expect(@lb_arr).to be_kind_of Array
        expect(@lb_arr[0]).to be_kind_of LieBracket
      end
    #
      it "is a [a,b]+[x,y]+[a,x] for the word 'ax'" do
        expect(@lb_arr.to_s).to eq '[a,b]+[x,y]+[a,x]'
      end
    end
    #
  end

end
# #---------------------------------
# describe "" do
#   context "" do
#     int { }
#   end
# end
# #---------------------------------

#End of File
