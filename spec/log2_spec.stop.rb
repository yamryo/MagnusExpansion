#
# log2_spec.rb
#
# Time-stamp: <2014-03-12 18:51:00 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('pry')
require('pry-byebug')

require('StdMagnusExp')

Theta_std = StdMagnusExp.instance

#---------------------------------
describe "#log2" do
  before :all do
    @gen_a = Generator.new('a')
    @gen_1 = Generator.new('1')
  end
  #  
  context "return a FormalSum" do
    subject { Theta_std.log2(@gen_a) }
    it { should be_kind_of(FormalSum) }
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
