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

    def initialize(bsd)
      @bsd = bsd
    end

    def self.unknown?(val)
      !I18n.translate('isobsd.sizes').has_key?(val)
    end

    def unknown?
      Size.unknown?(@bsd)
    end

    def to_s
      @bsd.to_s
    end

    def to_sym
      @bsd.to_s.to_sym
    end

    def to_i
      @bsd.to_i
    end

    def <=>(other)
      self.to_i <=> other.to_i
    end

    def diameter
      @diam ||= "#{@bsd}mm"
      @diam
    end

    def trad
      lookup(:trad)
    end

    def app
      lookup(:app)
    end

    def rarity(rarity_data = nil)
      if rarity_data.nil?
        # Only cache when default rarity being used
        @rarity ||= Rarity::Value.new(@bsd, rarity_data)
        return @rarity
      else
        return Rarity::Value.new(@bsd, rarity_data)
      end
    end

    def hash
      {
        :diameter => self.diameter,
        :app => self.app,
        :trad => self.trad,
        :rarity => self.rarity.to_s
      }  
    end

    def Size.all
      @all ||= SizeCollection.new(I18n.translate('isobsd.sizes').keys)
      @all 
    end

    private

    # Lookup the attribute for the given key
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

    def data
      @data ||= (unknown?) ? SizeUnknown.new(@bsd) : I18n.translate("isobsd.sizes")[@bsd]
      @data
    end

  end # class Size

  class SizeCollection

    include Enumerable

    def initialize(data=[])
      @list = data
    end

    def sizes
      @sizes ||= select_sizes
      @sizes
    end

    def each
      self.sizes.each do |s|
        yield s
      end
    end

    def include?(val)
      @list.include?(val)
    end

    # Returns a hash of structure
    # { bsd => {:diameter => "diameter", ... , :rarity => "rarity"}, ... }
    def hash
      Hash[sizes.map{|s| [s.to_i, s.hash]}]
    end

    # Returns a hash of structure
    # {"bsd" => "diameter", ...}
    # example: {"622" => "622mm", ... }
    def labels
      Hash[sizes.map{|s| [s.to_s, s.diameter]}]
    end

    # Returns an array of hashes structured as
    # [{:id=>"bsd", :text=>"diameter"}, ... ]
    def to_data
      sizes.map{|s| {:id=>s.to_s, :text=>s.diameter}}
    end

    private

    def select_sizes(size_data=nil)
      size_data ||= I18n.translate('isobsd.sizes')
      group = size_data.select{|k,v| (@list.include? k)}
      group.map{|k,v| Size.new(k)}
    end
  end # class SizeCollection

end
