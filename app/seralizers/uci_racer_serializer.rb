class UciRacerSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :previous_year_points,
             :cost,
             :category,
             :country,
             :country_short
end
