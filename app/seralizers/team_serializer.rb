class TeamSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :owner

  has_many :racers, :serializer => TeamUciRacerSerializer
end
