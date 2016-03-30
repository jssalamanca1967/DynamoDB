#!/usr/bin/env ruby
class DisenioController < ApplicationController
  #before_action :require_empresa, only: [:index, :show]
  $proyecto_actual
  $empresa_actual
  $disenio_edit

  def index
    @disenios = Disenio.all
  end

  def show
    @disenio = Diseniody.find(params[:id_disenio])
    @proyecto = Proyectody.find(params[:id_proyecto])
    @empresa = Empresady.find_by_nombre_empresa(params[:nombre_empresa])
  end

  def new
    @disenio = Disenio.new
    $proyecto_actual = Proyectody.find(params[:id_proyecto])
    @proyecto = $proyecto_actual
    $empresa_actual = Empresady.find_by_nombre_empresa(params[:nombre_empresa])
    @empresa = $empresa_actual
  end

  def create
    @disenio = Disenio.new(disenio_params2)
    if($disenio_nuevo == nil)
      puts("- " + $proyecto_actual.nombre)
      @proyecto = $proyecto_actual
      @empresa = $empresa_actual
      puts("--- " + $proyecto_actual.nombre)
      @disenio2 = $proyecto_actual.disenios.create(:nombre_diseniador => @disenio.nombre_diseniador ,:apellido_diseniador => @disenio.apellido_diseniador ,:estado => @disenio.estado ,:email_diseniador => @disenio.email_diseniador ,:precio_solicitado => @disenio.precio_solicitado)
      @disenio2.proyecto = $proyecto_actual
      if(@disenio2.save)
        procesarImagen(@disenio, @disenio2)
        redirect_to "/empresas/#{@empresa.nombre_empresa}/#{@proyecto.id}"
      else
        render 'new'
      end
    else
      update(@disenio)
    end
  end

  def edit
    @disenio = Disenio.find(params[:id_disenio])
    $disenio_edit = @disenio
    @proyecto = @disenio.proyecto
    @empresa = @proyecto.empresa
  end

  def update(disenio)
    @disenio_nuevo = disenio
    @disenio = $disenio_edit

    @disenio.nombre_diseniador = @disenio_nuevo.nombre_diseniador
    @disenio.apellido_diseniador = @disenio_nuevo.apellido_diseniador
    @disenio.estado = @disenio_nuevo.estado
    @disenio.email_diseniador = @disenio_nuevo.email_diseniador
    @disenio.precio_solicitado = @disenio_nuevo.precio_solicitado

    @proyecto = @disenio.proyecto
    @empresa = @proyecto.empresa
    if @disenio.save
      $disenio_edit = nil
      redirect_to "/empresas/#{@empresa.nombre_empresa}/#{@proyecto.id}"
    else
      render 'edit'
    end
  end

  def destroy
    @disenio = Disenio.find(params[:id_disenio])
    @proyecto = Proyecto.find(@disenio.proyecto_id)
    @empresa = Empresa.find(@proyecto.empresa_id)
    Disenio.delete(@disenio)
    redirect_to "/empresas/#{@empresa.nombre_empresa}/#{@proyecto.id}"
  end

  def self.prueba
    @disenios = Disenio.where(estado: "En proceso")
    @disenios.each do |d|
      procesarImagen(d)
    end
    print("Llego hasta aqui")
    SenderMail.prueba.deliver_now
  end

  private
    def disenio_params
      params.require(:disenio).permit(:nombre_diseniador, :apellido_diseniador, :estado, :precio_solicitado, :email_diseniador)
    end
  private
    def disenio_params2
      params.require(:disenio).permit(:nombre_diseniador, :apellido_diseniador, :estado, :precio_solicitado, :email_diseniador, :proyecto_id, :picture)
    end
  private
    def procesarImagen(disenio, disenio2)
      Thread.new do
        @disenio = disenio
        @disenio2 = disenio2
        print("Entro")
        direccion = "#{@disenio.picture.path}"
        print("Paso Direccion con correo #{@disenio.email_diseniador}")
        width = 800
        height = 600

        # the Magick class used for annotations
        gc = Magick::Draw.new
        gc.font = 'helvetica'
        gc.pointsize = 12
        gc.font_weight = Magick::BoldWeight
        gc.gravity = Magick::SouthGravity
        gc.fill = 'white'
        gc.undercolor = 'black'

        # the base image
        img = Magick::Image.read(direccion)[0].strip!
        print("[DESARROLLADOR] Lectura de la imagen\n")
        ximg = img.resize_to_fit(width, height)
        print("[DESARROLLADOR] Resize\n")
        # label the image with the method name

        print("[DESARROLLADOR] #{@disenio.created_at}")
        mensaje = "#{@disenio.nombre_diseniador} ::: #{@disenio.created_at}"

        lbl = Magick::Image.new(width, height)
        gc.annotate(ximg, 0, 0, 0, 0, mensaje)

        # save the new image to disk
        new_fname = "#{direccion}-[PROCESADA].png"
        ximg.write((new_fname))
        print("PROCESANDO #{direccion}\n")
        @disenio2.estado = "Disponible"
        @disenio2.picture = "#{@disenio.picture.url}"
        @disenio2.save
        #SenderMail.enviar(@disenio).deliver_now
        #Awsmailer.enviar(@disenio)


        @proyecto = @disenio2.proyecto
        @empresa = @proyecto.empresa

        puts(":v asdasdadasdasdasdas")
        # load credentials from disk
	      ses = Aws::SES::Client.new(

          region: 'us-west-2',
          access_key_id: ENV['AWSAccessKeyId'],
          secret_access_key: ENV['AWSSecretKey']
        )


        puts ("-------------.-------------------")

        resp2 = ses.send_email({
          source: "designmatch@outlook.com", # required
          destination: { # required
            to_addresses: ["#{@disenio.email_diseniador}", "js.salamanca1967@uniandes.edu.co"],
          },
          message: { # required
            subject: { # required
              data: "Tu diseño ya está listo!", # required
            },
            body: { # required
              text: {
                data: "Leeeeel", # required
              },
              html: {
                data: "<p>Tu diseño, creado el #{@disenio.created_at} para el proyecto #{@proyecto.nombre} de la empresa #{@empresa.nombre_empresa} ya está disponible.</p>", # required
                },
              },
            },
          })




        puts("---------------------- " + resp2.message_id)

      end
    end
end
