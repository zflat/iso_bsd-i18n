require 'i18n'
require 'json'

module IsoBsdI18n

  # Define a default rarity or allow for configuration at run time?
  class Rarity

    def initialize(common=nil, uncommon=nil, rare=nil)
      @common = common
      @uncommon = uncommon
      @rare = rare
    end

    def common_list
      @common ||= %w[630 622 559 507 406 305]
      @common
    end

    def uncommon_list
      @uncommon ||= %w[590 571]
      @uncommon
    end

    def rare_list
      @rare ||= %w[635 599 587 584 547 540 520 490 457 451 440 419 390 369 355 349 340 337 203 152]
      @rare
    end

    def common_sizes
      query_sizes(common_list)
    end

    def uncomon_sizes
      query_sizes(uncommon_list)
    end

    def rare_sizes
      query_sizes(rare_list)
    end

    def rare?(size)
      rare_list.include? size.to_s
    end

    def common?(size)
      common_list.include? size.to_s
    end

    def uncommon?(size)
      uncommon_list.include? size.to_s
    end

    private

    def query_sizes(list)
      sizes = {}
      Size.in_list(list)
    end

  end

  class NoData < String
    def initialize(str = nil)
      super(I18n.translate('errors.messages.not_applicable'))
    end
    
    def capitalize
      self.to_s
    end
  end

  class Size

    def initialize(bsd)
      @bsd = bsd
      @data = I18n.translate("isobsd.sizes.#{@bsd}")
    end

    def unknown?
      @data.class == String
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
      return @rarity unless @rarity.nil?

      rarity_data = Rarity.new(rarity_data) unless rarity_data.class == Rarity
      
      if rarity_data.rare? self
        @rarity = I18n.translate('rarity.rare')
      elsif rarity_data.common? self
        @rarity =  I18n.translate('rarity.common')
      elsif rarity_data.uncommon? self
        @rarity = I18n.translate('rarity.uncommon')
      else
        @rarity = NoData.new
      end

      @rarity
    end

    def to_h
      {
          :diameter => self.diameter,
          :app => self.app,
          :trad => self.trad,
          :rarity => self.rarity
        }  
    end

    def Size.to_h(list=nil)
      sizes = (list.nil?) ? Size.all : Size.in_list(list)
      Hash[sizes.map{|k,v| [k.to_s, v.to_h]}]
    end

    def to_json(*a)
      {
        'json_class' => self.class.name,
        'data' => self.to_h
      }.to_json(*a)
    end

    def Size.all
      return @all unless @all.nil?

      data = I18n.translate('isobsd.sizes')
      @all = {}
      data.each do |entry|      
        size = entry[0]
        @all[size.to_sym] = Size.new(size)
      end
      @all
    end

    def Size.in_list(list)
      data = I18n.translate('isobsd.sizes')
      set = {}
      data.each do |key, entry|      
        size = key
        if list.include? (size.to_s)
          set[size.to_sym] = Size.new(size)
        end
      end
      set
    end

    private

    def lookup(key)
      if unknown?
        return I18n.translate('errors.messages.unknown')
      else
        val = @data[key]
        val ||= NoData.new
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

  end

end
