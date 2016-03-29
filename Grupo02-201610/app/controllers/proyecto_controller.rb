class ProyectoController < ApplicationController
  def index
    @proyectos = Proyectody.all
  end

  def show
    @proyecto = Proyectody.find(params[:id])
    @empresa = Empresady.find_by_nombre_empresa(params[:nombre_empresa])
    ### NO ORDENA
    @disenios = @proyecto.disenios.where(estado: "Disponible")#.order(created_at: :desc)#.paginate(page: params[:page])
  end

  def new
    @proyecto = Proyecto.new
    @empresa = Empresady.find_by_nombre_empresa(params[:nombre_empresa])
  end

  def create
    @empresa = Empresady.find(current_empresa.id)
    @proyecto = @empresa.proyectos.create(proyecto_params)
    @proyecto.empresa = @empresa
    if(@proyecto.save)
      redirect_to "/empresas/#{@empresa.nombre_empresa}"
    else
      render 'new'
    end
  end

  def edit
    @proyecto = Proyectody.find(params[:id])
  end

  def update
    @proyecto = Proyectody.find(params[:id])
    @empresa = Empresady.find(@proyecto.empresa_id)
    if @proyecto.update_attributes(proyecto_params)
      redirect_to "/empresas/#{@empresa.nombre_empresa}"
    else
      render 'edit'
    end
  end

  def destroy
    @proyecto = Proyectody.find(params[:id])
    @empresa = Empresady.find(@proyecto.empresa_id)
    Proyectody.delete(@proyecto)
    redirect_to "/empresas/#{@empresa.nombre_empresa}"
  end

  private
    def proyecto_params
      params.require(:proyecto).permit(:nombre, :descripcion, :valor_pagar)
    end
  private
    def proyecto_params2
      params.require(:proyecto).permit(:nombre, :descripcion, :valor_pagar, :empresa_ids)
    end
end
