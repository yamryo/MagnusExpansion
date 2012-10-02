#
# SympMagnusExp_spec.rb
#
# Time-stamp: <2012-10-02 11:46:54 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('pry')
require('pry-nav')

require('SympMagnusExp')

Theta_symp = SympMagnusExp.instance

describe SympMagnusExp do
  #---------------------------------
  describe "when initialized" do
    it{ Theta_symp.mod_deg.should == 4 }
  end
  #---------------------------------

#---------------------------------
  describe "#expand" do
    before :all do
      @gen_a = Generator.new('a')
       @gen_1 = Generator.new('1')
     end
     #  
    context "return a FormalSum" do
      subject { Theta_symp.expand(@gen_a) }
      it { should be_kind_of(FormalSum) }
    end
    #
#     context "for generators" do
#       context "theta_std('a')" do
#         subject { Theta_symp.expand(@gen_a.dup).to_s }
#         it { should == '1+a'}
#       end
#       #
#       context "theta_std('A')" do
#         subject { Theta_symp.expand(@gen_a.inverse).to_s }
#         it { should == '1-a+aa-aaa'}
#       end
#       #
#       context "theta_std('1')" do
#         subject { Theta_symp.expand(@gen_1).to_s }
#         it { should == '1'}
#       end
#     end
#     #
#     context "theta_std('ab')" do
#       # theta_std('ab') = (1+a)(1+b) = 1+a+b+ab
#       subject { Theta_symp.expand(Word.new('ab')).to_s }
#       it { should == '1+a+b+ab'}
#     end
#     #
#     context "theta_std('aA')" do
#       subject { Theta_symp.expand(Word.new('aA')).to_s }
#       it { should == '1'}
#     end
#     #
#     context "theta_std('abA')" do
#       # theta_std('aBA') = (1+a)(1+b)(1-a+aa-aaa) = 1+b+ab-ba-aba+baa-aaaa+abaa-baaa-abaaa
#       subject { Theta_symp.expand(Word.new('abA')).to_s }
#       it { should == '1+b+ab-ba-aba+baa'}
#     end
#     #
#     context "degree 0 to 2 parts of theta_std('abAB')" do
#       subject do 
#         pdt = Theta_symp.expand(Word.new('abAB'))
#         pdt.homo_part(0..2).sort.to_s 
#       end
#       it { should == '1+ab-ba'}
#     end
#     #
#     context "theta_std('Bab')" do
#       # theta_std('Bab') = (1-b+bb-bbb)(1+a)(1+b)
#       #                  = (1+a-b-ba+bb+bba-bbb-bbba)(1+b) 
#       #                  = 1+a+ab-ba+bba-bbba-bab+bbab-bbbb-bbbab
#       subject { Theta_symp.expand(Word.new('Bab')).homo_part(0..3).to_s }
#       it { should == '1+a+ab-ba-bab+bba'}
#     end
#     #
#     context "theta_std('bAcaBC')" do
#       subject { Theta_std.expand(Word.new('bAcaBC')).homo_part(1).show }
#       it { should == '(0)1'}
#     end
#     #
#     context "theta_std('bAcaB')" do
#       subject { Theta_symp.expand(Word.new('bAcaB')).homo_part(2).show }
#       it { should == '(-1)ac+(1)bc+(1)ca+(-1)cb'}
#     end
#     #
#     context "theta_std('bAcaB')-FromalSum('ca-ac')" do
#       subject { (Theta_symp.expand(Word.new('bAcaB'))-FormalSum.new('ca-ac')).homo_part(2).simplify.show }
#       it { should == '(0)ac+(0)ca+(1)bc+(-1)cb'}
#     end
#     #
#     context "theta_std('cBDdaA')" do
#       subject { Theta_symp.expand(Word.new('cBDdaA')).homo_part(3).show }
#       it { should == '(-1)bbb+(1)cbb'}
#     end
#     #
#     context "theta_std(a word contractible into '1')" do
#       ['aA', 'ZaAz', 'cBDdaAbC'].each do |str|
#         it { Theta_symp.expand(Word.new(str)).show.should == '(1)1' }
#       end
#     end
#     #
   end
#   #---------------------------------
end

  # #---------------------------------
  # describe "" do
  #   context "" do
  #     int { }
  #   end
  # end
  # #---------------------------------

#End of File
