require 'i18n'
require_relative 'size'
require_relative 'division'

module IsoBsdI18n

  # Classify Size instances based on rarity.
  # Used to help distinguish similar sizes.
  # 
  module Rarity

    COMMON = [630, 622, 559, 507, 406, 305] unless defined?(COMMON)
    UNCOMMON = [590, 597, 571] unless defined?(UNCOMMON)
    RARE = [635, 599, 587, 584, 547, 540, 520,
            490, 457, 451, 440, 419, 390, 369,
            355, 349, 340, 337, 317, 203, 152, 137] unless defined?(RARE)

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

    # Rarity value object to be used as an attribute to Size instances
    # 
    class Value
      
      # @param [Integer] bsd
      # @param [Division, #each_pair] division rarity classifications
      def initialize(bsd, division=nil)
        @bsd = bsd
        self.division=division
        @data = ValueData.new(@bsd, @division)
        self.extend @data.to_mod
      end

      # @return [String] Translated rarity
      def to_s
        return @str unless @str.nil?
        
        @division.hash.keys.each do |k|
          if self.send("#{k}?")
            @str = I18n.translate("isobsd.rarity.#{k}")
          end
        end
        @str ||= AttribNoData.new

        @str
      end

      private 

      # Initialize the Division object used to test for rarity
      # 
      def division=(div)
        @division = div if div.class == Division
        @division ||= Division.new(div) if div.respond_to?(:each_pair)
        @division ||= Rarity::default_division
      end

      # Defining methods on the fly for Value instances
      class ValueData
        def initialize(bsd, division)
          @diameter = bsd
          @div = division
          @membership = {}
        end

        # @return [Module] A Value instance extends on initialization
        def to_mod
          div = @div
          h = div.hash
          diam = @diameter
          mem = @membership
          Module.new do
            h.each_pair do |gname, collection|
              define_method "#{gname}?" do
                mem[gname] ||= div.send("#{gname}?", diam)
                mem[gname]
              end
            end # h.each_pair do
          end
        end
      end # class ValueData
      
    end # class Value

  end # module Rarity

end
