require 'i18n'
require_relative 'size'

module IsoBsdI18n

  module Rarity

    COMMON = [630, 622, 559, 507, 406, 305] 
    UNCOMMON = [590, 571]
    RARE = [635, 599, 587, 584, 547, 540, 520,
            490, 457, 451, 440, 419, 390, 369,
            355, 349, 340, 337, 203, 152,]

    class Division
      def initialize(optns={})
        common = optns[:common]
        common ||= COMMON
        
        uncommon = optns[:uncommon]
        uncommon ||= UNCOMMON
        
        rare = optns[:rare]
        uncommon ||= RARE
        
        @common = SizeCollection.new(common)
        @uncommon = SizeCollection.new(uncommon)
        @rare = SizeCollection.new(rare)
      end
      
      def common
        @common
      end
      
      def uncommon
        @uncommon
      end

      def rare
        @rare
      end

      def common?(val)
        @common.include?(val)
      end
      
      def uncommon?(val)
        @uncommon.include?(val)
      end

      def rare?(val)
        @rare.include?(val)
      end

    end # class Division

    class Value
      def initialize(bsd, division=nil)
        @bsd = bsd
        @division = division
        @division ||= Division.new
      end

      def to_s
        return @str unless @str.nil?

        if self.common?
          @str = I18n.translate('isobsd.rarity.common')
        elsif self.uncommon?
          @str = I18n.translate('isobsd.rarity.uncommon')
        elsif self.rare?
          @str = I18n.translate('isobsd.rarity.common')
        else
          @str = AttribNoData.new
        end

        @str
      end

      def common?
        @is_common ||= @division.common? @bsd
        @is_common
      end

      def uncommon?
        @is_uncommon ||= @division.uncommon? @bsd
        @is_uncommon
      end

      def rare?
        @is_rare ||= @division.rare? @bsd
        @is_rare
      end

    end # class Value

  end # module Rarity

end
