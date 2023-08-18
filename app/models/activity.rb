class Activity < ApplicationRecord
  include PgSearch::Model

  belongs_to :source, polymorphic: true
  belongs_to :user

  pg_search_scope :content_search,
                  against: :content,
                  using: {
                    tsearch: {
                      highlight: {
                        StartSel: "<span class='search-highlight'>",
                        StopSel: "</span>"
                      }
                    }
                  }

  class << self
    def ransackable_associations(*)
      %w[]
    end

    def ransackable_attributes(*)
      %w[content remote_created_at source_type user_id]
    end

    def ransackable_scopes(*)
      %w[content_search]
    end
  end
end
