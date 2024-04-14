# frozen_string_literal: true

# spec/support/active_record_mocks.rb

# module ActiveRecord
#   class Relation
#     include Enumerable

#     def initialize(*records)
#       @records = records.flatten
#     end

#     def each(&block)
#       @records.each(&block)
#     end

#     def size
#       @records.size
#     end
#   end
# end
