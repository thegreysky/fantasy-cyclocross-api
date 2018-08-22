class UciRacer < ApplicationRecord
  attr_accessor :active
  attr_accessor :results

  def points
    results.map(&:points).inject(0, &:+)
  end

  def race_results
    p results
    results.map(&:uci_result)
  end
end
