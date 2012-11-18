require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'iso_bsd-i18n'
module IsoBsdI18n
  describe Size do

    it "should recognize known sizes" do
      data_set = I18n.translate('isobsd.sizes')
      s = data_set.first
      Size.unknown?(s[0]).should == false
    end

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
      
      it "should have sizes with known attributes" do
        size = Size.all.sizes.first
        u_class = SizeUnknown.new(size.to_i).class

        size.diameter.class.should_not == u_class
        size.trad.class.should_not == u_class
        size.app.class.should_not == u_class
      end
    end

  end
end
