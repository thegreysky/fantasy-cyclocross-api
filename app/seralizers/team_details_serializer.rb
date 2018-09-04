class TeamDetailsSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :owner,
             :points,
             :paid

  has_many :racers, :serializer => TeamWithResultsUciRacerSerializer
end
