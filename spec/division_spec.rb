require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'iso_bsd-i18n'
module IsoBsdI18n

  describe Division  do

    describe "a customized division" do
      before(:all) do
        @list = {:common => [630], :uncommon => [622], :rare => [590]}
        @division = Division.new(@list)
      end

      it "should have common, uncommon and rare matching custom list" do
        @division.common.sizes.length.should == @list[:common].length
        @division.uncommon.sizes.length.should == @list[:uncommon].length
        @division.rare.sizes.length.should == @list[:rare].length
      end
    end


    describe "a (default) division" do
      before(:each) do
        @d = Division.new
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

          it "should have rarity that evaluate to be common" do
            @sizes.first.rarity.should be_common
          end

          it "should not have rarity that evaluates to rare or uncommon" do
            @sizes.first.rarity.should_not be_rare
            @sizes.first.rarity.should_not be_uncommon
          end

          it "should map to the 'common' label" do
            str = @sizes.first.rarity.to_s
            str.should == I18n.translate('isobsd.rarity.common')
          end
        end # describe "sizes"
      end # describe "common"
    end # describe "a new division"

  end # describe Division
end # module IsoBsdI18n
