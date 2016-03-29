class Empresady
  include Dynamoid::Document

  table :name => :empresa, :key => :id, :read_capacity => 400, :write_capacity => 400
  field :password_digest
  field :email
  field :nombre_empresa
  field :nombre_empresa_real
  field :created_at, :datetime

  has_many :proyectos ,:class => Proyectody

end
