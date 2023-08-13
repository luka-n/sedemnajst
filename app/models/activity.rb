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
end
