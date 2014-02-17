#
# GrouplikeExp_spec.rb
#
# Time-stamp: <2014-02-04 15:30:02 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('pry')
require('pry-nav')

require('GrouplikeExp')
#require('LieBracket')
#require('FormalSum')

Theta_gl = GrouplikeExp.instance

#---------------------------------
describe "#log2" do
  before :all do
    @gen_1 = Generator.new('1')
    @gen_a = Generator.new('a')
    @gen_b = Generator.new('b')
    @gen_s = Generator.new('s')
    @gen_t = Generator.new('t')
    @gen_x = Generator.new('x')
    @gen_y = Generator.new('y')
  end
  #  
#  context "return Zero for 1" do
#    it { Theta_gl.log2(@gen_1).should == Zero }
#  end
  #
  context "return a LieBracket" do
    subject { Theta_gl.log2(@gen_x) }
    it { should be_kind_of(LieBracket) }
  end
  #
  describe "for generators" do

    context "return a [x,y] for x" do
      it { Theta_gl.log2(@gen_a).to_s.should == '[a,b]' }
      it { Theta_gl.log2(@gen_s).to_s.should == '[s,t]' }
      it { Theta_gl.log2(@gen_x).to_s.should == '[x,y]' }
    end
  #
    context "return a -[x,y] for y" do
      it { Theta_gl.log2(@gen_b).to_s.should == '-[a,b]' }
      it { Theta_gl.log2(@gen_t).to_s.should == '-[s,t]' }
      it { Theta_gl.log2(@gen_y).to_s.should == '-[x,y]' }
    end
  #
  end
  #
  describe "for words" do
    before :all do 
      @word_ax = Word.new('ax')
    end
  #
    context "return a [a,b]+[x,y]+[a,x] for ax" do
      subject{ Theta_gl.log2(@word_ax).to_s }
      it { should == '[a,b]+[x,y]+[a,x]' }
    end
  end
  #
end

  # #---------------------------------
  # describe "" do
  #   context "" do
  #     int { }
  #   end
  # end
  # #---------------------------------

#End of File
