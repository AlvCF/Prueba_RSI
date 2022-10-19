class Cuenta
  require_relative 'Transferencia'

  attr_accessor :titular, :dinero, :banco, :historial
  

  def initialize(titular, banco)
    @titular = titular
    @banco = banco
    @dinero = 0
    @historial = []
    banco.cuentas << self
  end


  def añadir_dinero(dinero)
    self.dinero += dinero
  end

  def retirar_dinero(dinero)
    if self.dinero >= dinero
      self.dinero -= dinero
    end
  end

  def transferencia_interna(cuenta, dinero)
    if cuenta.banco == self.banco
      if dinero <= self.dinero
        transf = Transferencia.new(self, cuenta, dinero, true, true)

        self.historial << transf
        cuenta.historial << transf
        puts "Transferencia completada con éxito"
      else
        puts "Saldo insuficiente para completar la transacción"
      end
    else
      puts "El cliente de destino no pertenece a su mismo banco. Por favor, realice una transferencia externa"
    end
  end

  def transferencia_externa(cuenta, dinero)
    if cuenta.banco != self.banco
      if dinero <= (self.dinero - 5)
        if dinero <= 1000
          self.dinero -= 5
          if rand(100) < 70
            transf = Transferencia.new(self, cuenta, dinero, false, true)

            self.historial << transf
            cuenta.historial << transf
            puts "La transferencia se ha completado con éxito"
            return true
          else
            transf = Transferencia.new(self, cuenta, dinero, false, false)

            self.historial << transf
            cuenta.historial << transf
            puts "La transferencia ha fallado"
            return false
          end
        else
          puts "El límite para transferencias externas es de 1000€"
        end
      else
        puts "Saldo insuficiente para completar la transacción"
      end
    else
      puts "El cliente de destino pertenece a su mismo banco. Por favor, realice una transferencia interna"
    end
  end

  def agente_de_transferencia(cuenta_destino, dinero_total)
    limite = 1000
    num_intentos_inicial = (dinero_total.to_f/1000).ceil
    num_aprox_intentos = calculo_intentos(num_intentos_inicial, 0.7)
    if self.dinero > (dinero_total + (num_aprox_intentos * 5))
      cont = 0
      while cont < (num_intentos_inicial)
        if cont == (num_intentos_inicial - 1)
          if transferencia_externa(cuenta_destino, dinero_total%limite)
            cont += 1
          end 
        else
          if transferencia_externa(cuenta_destino, limite)
            cont += 1
          end
        end
      end
    else
      puts "No dispone de suficiente dinero para que la operación se pueda realizar con la suficiente certeza"
    end
  end

  private

    def calculo_intentos(requeridos, probabilidad)
      margen = 0.99
      cont = requeridos 
      prob_final = 0.0
      while prob_final < margen
        prob_final = complementaria_binomial(20,cont,probabilidad)
        cont += 1
      end

      return cont
    end

    def complementaria_binomial(intentos_requeridos, intentos_totales, probabilidad)
      cont = 0.0
      for a in 0..intentos_requeridos
        cont += combinaciones(intentos_totales, a) * probabilidad**a *(1-probabilidad)**(intentos_totales-a)
      end
      return 1-cont
    end

    def combinaciones(x,y)
      return factorial(x) / (factorial(y) * factorial(x-y))
    end

    def factorial(x)
      return (1..x).inject(:*) || 1
    end


end