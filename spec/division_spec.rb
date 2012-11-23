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

      describe "#hash" do
        it "should produce the original list" do
          @division.hash.should == @list
        end
      end
    end

  end # describe Division
end # module IsoBsdI18n
