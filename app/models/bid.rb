class Bid < ActiveRecord::Base
  include TimeScopes

  belongs_to :user
  belongs_to :product, counter_cache: true
  has_many :events, -> { order(created_at: :asc) }, dependent: :destroy

  validates :user, presence: true
  validates :product, presence: true, uniqueness: { scope: :user }

  def queue_index
    product.bids.where(Bid.arel_table[:created_at].lt(created_at)).count
  end
end
