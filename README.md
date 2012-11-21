# iso_bsd-i18n

Text data for describing ISO Bead Seat Diameters for bicycle wheels.

For background, see
http://www.sheldonbrown.com/tire-sizing.html#isoetrto


## Usage

        require 'iso_bsd-i18n'
        
        s = IsoBsdI18n::Size.new(622)
        # Application(s)
        s.app
        # Traditional name(s)
        s.trad
        # Rarity information
        s.rarity
        # Test if common size
        s.rarity.commmon?
                
        # SizeCollection of all sizes
        IsoBsdI18n::Size.all

# License

See license file.

