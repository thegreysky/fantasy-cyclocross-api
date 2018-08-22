class TeamDetailsSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :owner,
             :points

  has_many :racers, :serializer => TeamWithResultsUciRacerSerializer
end
