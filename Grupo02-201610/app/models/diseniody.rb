class Diseniody
  include Dynamoid::Document

  table :name => :disenio, :key => :id, :read_capacity => 400, :write_capacity => 400
  field :nombre_diseniador
  field :apellido_diseniador
  field :estado
  field :email_diseniador
  field :precio_solicitado
  field :picture

  belongs_to :proyecto ,:class => Proyectody

  field :created_at, :datetime


end
