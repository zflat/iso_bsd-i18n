require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'iso_bsd-i18n'
module IsoBsdI18n
  describe Rarity::Division  do

    describe "a new division" do
      before(:each) do
        @d = Rarity::Division.new
      end

      it "should have common, uncommon and rare" do
        @d.common.should_not be_nil
        @d.uncommon.should_not be_nil
        @d.rare.should_not be_nil
      end

      describe "common, uncommon and rare" do
        it "should be the same type" do
          @d.common.class.should == @d.uncommon.class
          @d.rare.class.should == @d.common.class
        end
      end

      describe "common" do
        before(:each) do
          @c = @d.common
        end
        it "should be a collection" do
          @c.class.should == SizeCollection.new.class
        end

        describe "sizes" do
          before(:each) do
            @sizes = @c.sizes
          end
          it "should be an array" do
            @sizes.class.should == [].class
          end

          it "should have array elements of type Size" do
            @sizes.first.class.should == Size.new(0).class
          end
        end # describe "sizes"
      end # describe "common"
    end # describe "a new division"

  end # describe Rarity::Division
end # module IsoBsdI18n
