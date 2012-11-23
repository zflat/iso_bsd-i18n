require 'i18n'

module IsoBsdI18n

    # A Division encapsulates the classification of wheels into 
    # specified non-intersecting groups.
    class Division
      
      # @param [Hash, #each_pair] group_list Hash mapping division to array of sizes in the division
      def initialize(group_list)
        @raw_groups = group_list
        @data = DivisionData.new(@raw_groups)
        self.extend @data.to_mod
      end

      def hash
        @raw_groups
      end

      def == (other)
        @raw_groups == other.hash
      end

      private

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
      end # class DivisionData

    end # class Division
end # module BsdIsoI18n
