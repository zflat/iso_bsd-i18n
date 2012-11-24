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

    describe "all" do
      it "should be a collection" do
        Size.all.class.should == SizeCollection
      end

      it "should contain Size elements in the collection" do
        Size.all.first.class.should == Size
      end
      
      it "should have sizes with known attributes" do
        size = Size.all.first
        u_class = SizeUnknown.new(size.to_i).class

        size.diameter.class.should_not == u_class
        size.trad.class.should_not == u_class
        size.app.class.should_not == u_class
      end
    end

    describe "SizeCollection" do
      before(:each) do
        @collection = Size.all
      end
      describe "#hash_locale" do
        it "should have as many top level elements as specified locales" do
          n = 1
          h = @collection.hash_locale([I18n::available_locales.first])
          h.keys.count.should == n
        end
      end
    end
    
  end
end
