require 'i18n'
require_relative 'size'
require_relative 'division'

module IsoBsdI18n

  module Rarity
    
    COMMON = [630, 622, 559, 507, 406, 305] unless defined?(COMMON)
    UNCOMMON = [590, 571] unless defined?(UNCOMMON)
    RARE = [635, 599, 587, 584, 547, 540, 520,
            490, 457, 451, 440, 419, 390, 369,
            355, 349, 340, 337, 203, 152,] unless defined?(RARE)

    # The Division object used to classify size rarity.
    # Used by default when explicit division is not specifed
    # for Rarity functions.
    #
    # @return [Division]
    def self.default_division
      @default_division ||= Division.new(self.default_division_raw)
      @default_division
    end
    
    # Configure the default to specify rarity divisions.
    # When nil is given, the default is defined based on 
    # COMMON, UNCOMMON and RARE lists.
    # 
    # @param [Hash, Division, nil] d
    def self.default_division=(d)
      if d.class == Division
        @default_division = d
      else
        d = nil unless d.respond_to?(:each_pair)
        d ||= self.default_division_raw
        @default_division = Division.new(d)
      end
      return @default_division
    end

    # Get the Hash to specify a default division based on 
    # COMMON, UNCOMMON and RARE lists
    # @return [Hash]
    def self.default_division_raw
      {
        :common => COMMON,
        :uncommon => UNCOMMON,
        :rare => RARE
      }
    end

    class Value
      
      # @param [Integer] bsd
      # @param [Division, #each_pair] division rarity classifications
      def initialize(bsd, division=nil)
        @bsd = bsd
        @division = division if division.class == Division
        @division ||= Division.new(division) if division.respond_to?(:each_pair)
        @division ||= Rarity::default_division
      end

      def to_s
        return @str unless @str.nil?

        if self.common?
          @str = I18n.translate('isobsd.rarity.common')
        elsif self.uncommon?
          @str = I18n.translate('isobsd.rarity.uncommon')
        elsif self.rare?
          @str = I18n.translate('isobsd.rarity.rare')
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

      private 

      #TODO define methods on the fly
      class ValueData
        def initizlize(bsd)
          
        end
      
      end # class ValueData
      
    end # class Value

  end # module Rarity

end
