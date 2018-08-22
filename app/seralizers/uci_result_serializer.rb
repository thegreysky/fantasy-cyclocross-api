class UciResultSerializer < ActiveModel::Serializer
  attributes :competition_name,
             :category,
             :place,
             :points
end
