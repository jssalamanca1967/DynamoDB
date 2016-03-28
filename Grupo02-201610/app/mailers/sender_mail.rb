  #!/usr/bin/env ruby
class SenderMail < ApplicationMailer
  def enviar(disenio)
    @disenio = disenio
    print("[DESARROLLADOR] #{@disenio.email_diseniador}")
    @proyecto = Proyecto.find(@disenio.proyecto_id)
    @empresa = Empresa.find(@proyecto.empresa_id)

      options = { :address              => "smtp.gmail.com",
                  :port                 => 587,
                  :user_name            => 'designmatch2@gmail.com',
                  :password             => 'contrasenia.27',
                  :authentication       => 'plain',
                  :enable_starttls_auto => true  }


      Mail.defaults do
        delivery_method :smtp, options
      end

      mail = Mail.new do
        from    'designmatch2@gmail.com'
        subject 'Tu diseño está listo'
      end
      mail.to("#{@disenio.email_diseniador}")
      mail.body("Tu diseño, creado el #{@disenio.created_at} para el proyecto #{@proyecto.nombre} de la empresa #{@empresa.nombre_empresa} ya está disponible.")

      mail.deliver
  end

  def prueba
    options = { :address              => "smtp.gmail.com",
                :port                 => 587,
                :user_name            => 'designmatch2@gmail.com',
                :password             => 'contrasenia.27',
                :authentication       => 'plain',
                :enable_starttls_auto => true  }


    Mail.defaults do
      delivery_method :smtp, options
    end

    mail = Mail.new do
      from    'designmatch2@gmail.com'
      subject 'Tu diseño está listo'
    end
    mail.to("johnathansalamanca@gmail.com")
    mail.body("Tu diseño, creado el ")

    mail.deliver
  end
end
