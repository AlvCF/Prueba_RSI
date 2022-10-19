class Transferencia
  attr_accessor :cuenta_origen, :cuenta_destino, :dinero, :intra_banco, :exito

  def initialize(cuenta_origen, cuenta_destino, dinero, intra_banco, exito)
    @cuenta_origen = cuenta_origen
    @cuenta_destino = cuenta_destino
    @dinero = dinero
    @intra_banco = intra_banco
    @exito = exito
    cuenta_destino.dinero += dinero if exito
    cuenta_origen.dinero -= dinero if exito
    #movimiento_de_dinero(cuenta_origen, cuenta_destino, dinero)
  end

  # def movimiento_de_dinero(origen, destino, dinero)
  #   origen.dinero -= dinero
  #   destino.dinero += dinero  
  # end
end