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

  class SizeUnknown
    def initialize(bsd)
      @bsd = bsd
    end

    def to_s
      I18n.translate('isobsd.messages.unknown')
    end
  end

  class Size

    def initialize(bsd)
      @bsd = bsd

      @data = (Size.unknown?(@bsd)) ?
        SizeUnknown.new(@bsd) :
        I18n.translate("isobsd.sizes.#{@bsd}")
    end

    def self.unknown?(val)
      I18n.translate('isobsd.sizes').has_key?(val)
    end

    def unknown?
      @data.class == SizeUnknown
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

    def diameter
      "#{@bsd}mm"
    end

    def trad
      lookup(:trad)
    end

    def app
      lookup(:app)
    end

    def rarity(rarity_data = nil)
      @rarity ||= Rarity::Value.new(@bsd, rarity_data)
      @rarity
    end

    def hash
      {
        :diameter => self.diameter,
        :app => self.app,
        :trad => self.trad,
        :rarity => self.rarity
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
        return @data
      else
        val = @data[key]
        val ||= AttribNoData.new
      end

      # Convert multi-lined entries to an array
      if val.class == Hash
        val2 = []
        val.each do |k,v|
          val2 << v
        end
        val = val2
      end
      return val
    end

  end # class Size

  class SizeCollection
    def initialize(data=[])
      @list = data
    end

    def sizes
      @sizes ||= select_sizes
      @sizes
    end

    def include?(val)
      @list.include?(val)
    end

    def hash
      Hash[sizes.map{|s| [s.to_i, s.hash]}]
    end

    def to_a
      Hash[sizes.map{|s| [s.to_s, s.diameter]}]
    end

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
