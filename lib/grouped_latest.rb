module GroupedLatest
  extend ActiveSupport::Concern
  included do
    cattr_accessor :latest_column, :latest_strategy
    self.latest_column = :id
    self.latest_strategy = :gl_arel_in

    scope :grouped_latest, -> grouped {
      send(latest_strategy, grouped)
    }

    class << self
      def gl_arel_in(grouped)
        table = arel_table
        max = table.project(table[latest_column].maximum).group(grouped)
        where(table[latest_column].in(max))
      end

      def gl_arel_exists(grouped)
        table = arel_table
        sub = arel_table.alias('sub')
        select = table.where(table[grouped].eq(sub[grouped]))
                   .where(table[latest_column].lt(sub[latest_column]))
                   .project('1').from(sub)
        where(select.exists.not)
      end

      def gl_array_in(grouped)
        max = group(grouped).maximum(latest_column).values
        where(latest_column => max)
      end
    end
  end
end

