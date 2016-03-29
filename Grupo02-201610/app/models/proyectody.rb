class Proyectody
  include Dynamoid::Document

  table :name => :proyecto, :key => :id, :read_capacity => 400, :write_capacity => 400
  field :descripcion
  field :nombre
  field :valor_pagar

  belongs_to :empresa ,:class => Empresady
  has_many :disenios ,:class => Diseniody

  field :created_at, :datetime


end
