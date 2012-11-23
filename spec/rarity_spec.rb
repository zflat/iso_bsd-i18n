require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'iso_bsd-i18n'
module IsoBsdI18n

  describe Rarity do
    describe "the default division" do
      after(:each) do
        Rarity::default_division=nil
      end
      it "should not be nil" do
        Rarity::default_division.should_not be_nil
      end

      it "should be settable" do
        h = {:test=>[100]}
        Rarity::default_division = h
        Rarity::default_division.should == h
      end

      it "should be resettable" do
        h = {:test=>[100]}
        h_initial = Rarity::default_division
        Rarity::default_division = h
        Rarity::default_division = nil
        Rarity::default_division.should == h_initial
      end
    end
  end

  describe Rarity::Value do

    it "should allow for custom division data" do
      s = Size.all.first
      my_div_data = {:common => [s.to_i], :uncommon => [], :rare => []}
      s.rarity(my_div_data).should be_common

      my_div = Division.new({:common => [s.to_i], :uncommon => [], :rare => []})
      my_div.class.should == Division
      s.rarity(my_div).should be_common
    end

  end

end # module IsoBsdI18n
