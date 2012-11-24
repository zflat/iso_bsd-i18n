require 'i18n'

module IsoBsdI18n

  class AttribNoData < String
    def initialize(str = nil)
      str ||= I18n.translate('isobsd.messages.not_applicable')
      super(str)
    end

    def capitalize
      self.to_s
    end
  end

  class SizeUnknown < String
    def initialize(bsd)
      @bsd = bsd
      super(I18n.translate('isobsd.messages.unknown'))
    end
  end

  class Size

    # @param [Integer] bsd
    # 
    def initialize(bsd)
      @bsd = bsd
    end

    # Test if the given BSD value maps to known size data
    # 
    # @param [Integer, #to_i] val
    # 
    # @return [Boolean]
    def self.unknown?(val)
      !I18n.translate('isobsd.sizes').has_key?(val.to_i)
    end

    # Test if this size is unknown
    # 
    # @return [Boolean]
    def unknown?
      Size.unknown?(@bsd)
    end

    # @return [String] The bsd as string.
    #
    def to_s
      @bsd.to_s
    end

    def to_sym
      @bsd.to_s.to_sym
    end


    # @return [Integer] The bsd for this size.
    # 
    def to_i
      @bsd.to_i
    end

    def <=>(other)
      self.to_i <=> other.to_i
    end

    # @return [String] The bsd and units like 622mm
    #
    def diameter
      @diam ||= "#{@bsd}mm"
      @diam
    end

    # Traditional name or names of this size
    # @return [String, Array] 
    def trad
      lookup(:trad)
    end

    # Appliication(s) of this size
    # @return [String, Array]
    def app
      lookup(:app)
    end

    # Rarity of the size given rarity divisions
    #
    # @param [Division, #each_pair] rarity_data rarity classifications
    # 
    def rarity(rarity_data = nil)
      if rarity_data.nil?
        # Only cache when default rarity being used
        @rarity ||= Rarity::Value.new(@bsd, rarity_data)
        return @rarity
      else
        return Rarity::Value.new(@bsd, rarity_data)
      end
    end

    # Provides a hash containing all attributes
    # 
    # @return [Hash] of size attributes
    def hash
      {
        :diameter => self.diameter,
        :app => self.app,
        :trad => self.trad,
        :rarity => self.rarity.to_s
      }  
    end

    # @return [Array] All size information in an Array of Size objects
    def Size.all
      @all ||= SizeCollection.new(I18n.translate('isobsd.sizes').keys)
      @all 
    end

    private

    # Lookup the attribute for the given key
    # Returns an Array if multiple values map the the attribute
    #
    # @param [Symbol] key Attribute to lookup
    # @return [String, Array]
    def lookup(key)
      if unknown?
        return data
      end

      val = data[key]
      val ||= AttribNoData.new

      # Convert multi-lined entries to an array
      if val.class == Hash
        val = val.values
      end

      return val
    end

    # Wrapper for the I18n::translate call to retrieve wheel size data
    # @return [Hash] 
    def data
      @data ||= (unknown?) ? SizeUnknown.new(@bsd) : I18n.translate("isobsd.sizes")[@bsd]
      @data
    end

  end # class Size

  class SizeCollection

    include Enumerable

    # @param [Array] data List of sizes to include in the collection
    def initialize(data=[])
      @list = data
    end

    # Array of size objects in the collection
    # 
    # @return [Array]
    def sizes
      select_sizes(@list)
    end

    def each
      self.sizes.each do |s|
        yield s
      end
    end

    # Test if the given size is in the collection
    #
    # @param [Size, #==] val
    #
    # @return [Boolean]
    def include?(val)
      @list.include?(val)
    end

    # A nested hash of structure
    # { size.diameter => size.hash ,... }
    # 
    # @return (Hash) 
    def hash
      Hash[sizes.map{|s| [s.to_i, s.hash]}]
    end

    # @param [Array] locales String array specifying locales to include
    # @return [Hash] The hash for each Size in the collection for each locale specified
    def hash_locale(locales=nil)
      orig_locale = I18n.locale
      h = {}

      if(locales.nil? || locales.empty?)
        locales = I18n::available_locales
      end

      begin
        locales.each do |l|
          begin
            if ! I18n.translate('isobsd', :raise => true, :locale => l).nil?
              I18n.locale = l
              h[l] = self.hash
            end
          rescue
          end
        end
      ensure
        I18n.locale = orig_locale
      end
      return h
    end

    # Hash of structure
    # {size.bsd => size.diameter, ... }
    #
    #  @return [Hash]
    def labels
      Hash[sizes.map{|s| [s.to_s, s.diameter]}]
    end

    # Array of size.hash
    # 
    # @return [Array]
    def to_data
      sizes.map{|s| {:id=>s.to_s, :text=>s.diameter}}
    end

    private

    # @param [Array] targets List of sizes to include
    # @param [Hash] size_data Data set to build Size objects from
    # @return [Array] of Size objects
    def select_sizes(targets=nil,size_data=nil)
      size_data ||= I18n.translate('isobsd.sizes')
      group = size_data.select{|k,v| (targets.include? k)} unless targets.nil?
      group ||= size_data
      group.keys.map{|k| Size.new(k)}
    end
  end # class SizeCollection

end
