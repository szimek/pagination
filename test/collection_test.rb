require File.dirname(__FILE__) + '/test_helper'

class CollectionTest < Test::Unit::TestCase
  context "collection test" do
    setup do
      @collection = ('a'..'e').to_a
    end

    should "return elements from specific range" do
      # see: enumerable.rb
      # limit = per_page
      # offset = (current_page - 1) * limit
      [
        { :offset => 0,  :limit => 3,  :expected => %w( a b c ) },
        { :offset => 3,  :limit => 3,  :expected => %w( d e ) },
        { :offset => 0,  :limit => 5,  :expected => %w( a b c d e ) },
        { :offset => 6,  :limit => 3,  :expected => [] },
      ].
      each do |conditions|
        expected = conditions.delete :expected
        assert_equal expected, @collection.paginate(conditions)
      end
    end

    context "init pagination collection" do
      setup do
        @collection = [1,2,3,4,5]
        @paginated_collection = paginate_collection(@collection)
      end

      should "return total pages" do
        assert_equal 3, @paginated_collection.total_pages
      end

      should "return previous page" do
        assert_equal 1, @paginated_collection.previous_page
      end

      should "return next page" do
        assert_equal 3, @paginated_collection.next_page
      end

      should "array be shorter after paginate" do
        pag_array = paginate_collection(@collection, 1, 4)
        assert_not_equal  @collection, pag_array.count
        assert_equal 4, pag_array.count
      end

      should "rise an error InvalidPage" do
        assert_raise(Pagination::InvalidPage) { paginate_collection(@collection, -2, 2) }
        assert_raise(Pagination::InvalidPage) { paginate_collection(@collection, 1000, 2) }
      end

      should "rise an error ArgumentError" do
        assert_raise(ArgumentError) { paginate_collection(@collection, 2, -2) }
      end
    end

    context "having already paginated collection" do
      setup do
        @collection = (11..20).to_a
        class << @collection
          def total_entries; 100; end
          def current_page; 2; end
          def per_page; 10; end
        end

        @paginated_collection = paginate_collection(@collection, 1, 1, 1)
      end

      should "use attribute values of the original collection" do
        assert_equal @collection, @paginated_collection
        assert_equal @collection.total_entries, @paginated_collection.total_entries
        assert_equal @collection.current_page, @paginated_collection.current_page
        assert_equal @collection.per_page, @paginated_collection.per_page
      end
    end
  end

  private
    def paginate_collection(collection, current_page=2, per_page=2, total_entries=nil)
      Pagination::Collection.new(
            :collection => collection,
            :current_page => current_page,
            :per_page => per_page,
            :total_entries => total_entries
          )
    end
end
