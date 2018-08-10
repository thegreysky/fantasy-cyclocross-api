class TeamSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :owner

  has_many :uci_racers
end
