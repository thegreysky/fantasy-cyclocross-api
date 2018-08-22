class TeamSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :owner,
             :points

  has_many :racers, :serializer => TeamUciRacerSerializer
end
