class TeamSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :owner,
             :points,
             :paid

  has_many :racers, :serializer => TeamUciRacerSerializer
end
