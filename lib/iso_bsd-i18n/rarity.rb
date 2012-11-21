require 'i18n'
require_relative 'size'

module IsoBsdI18n

  module Rarity

    COMMON = [630, 622, 559, 507, 406, 305] unless defined?(COMMON)
    UNCOMMON = [590, 571] unless defined?(UNCOMMON)
    RARE = [635, 599, 587, 584, 547, 540, 520,
            490, 457, 451, 440, 419, 390, 369,
            355, 349, 340, 337, 203, 152,] unless defined?(RARE)

    def self.default_division
      @default_division ||= {
          :common => COMMON,
          :uncommon => UNCOMMON,
          :rare => RARE
        }
      @default_division
    end

    # Can be used to configure a different
    # default to use to specify rarity divisions
    def self.default_division=(h)
      @default_division = h
    end

    # Defining methods on the fly
    # http://blog.jayfields.com/2008/02/ruby-dynamically-define-method.html
    class DivisionData
      def initialize(data)
        @h = data
        @h ||= {}
        @groups = {} # holder for caching
      end

      def to_mod
        h = @h
        grps = @groups
        Module.new do
          h.each_pair do |gname, collection|
            define_method gname do
              col = grps[gname]
              col ||= SizeCollection.new(collection)
              grps[gname] = col
            end

            define_method "#{gname}?" do |bsd|
              col = grps[gname]
              col ||= SizeCollection.new(collection)
              col.include?(bsd)
            end
          end
        end
      end
    end

    class Division
      def initialize(group_list=nil)
        group_list ||= Rarity::default_division

        @data = DivisionData.new(group_list)

        self.extend @data.to_mod
      end
    end # class Division


    #TODO define methods on the fly
    class ValueData
      def initizlize(bsd)

      end
      
    end


    class Value
      def initialize(bsd, division=nil)
        @bsd = bsd
        @division = division if division.class == Division
        @division = Division.new(division) if division.class == Hash
        @division ||= Division.new
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

    end # class Value

  end # module Rarity

end
