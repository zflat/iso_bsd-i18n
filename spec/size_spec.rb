require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'iso_bsd-i18n'
module IsoBsdI18n
  describe Size do

    describe "a new size" do
      it "should have integer representation of bsd" do
        bsd = 100
        s = Size.new(bsd)
        s.to_i.should == bsd
      end
    end

    describe "all.sizes" do
      it "should be an array" do
        Size.all.sizes.class.should == [].class
      end

      it "should contain Size elements in the array" do
        Size.all.sizes.first.class.should == Size.new(0).class
      end
    end

  end
end
