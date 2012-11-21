# iso_bsd-i18n

Text data for describing ISO Bead Seat Diameters for bicycle wheels.

For background, see
http://www.sheldonbrown.com/tire-sizing.html#isoetrto

## Basic Usage

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
        c = IsoBsdI18n::Size.all

        # SizeCollection of common sizes
        # (based on default rarity divisions)
        c = IsoBsdI18n::Rarity::Division.new.common

        my_divisions = {:common=>[bsd,..], :uncommon=>[bsd,..], :rare=>[bsd]}
        
        # Testing rarity based on specified divisions
        s.rarity(my_divisions).common?
        
        # Override default rarity divisions
        Raridy::default_division = my_divisions

# License

See license file.

