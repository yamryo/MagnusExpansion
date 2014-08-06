#
# log2_spec.rb
#
# Time-stamp: <2014-08-05 10:59:10 (ryosuke)>
#
require('spec_helper')

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
    it { is_expected.to be_kind_of(FormalSum) }
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
