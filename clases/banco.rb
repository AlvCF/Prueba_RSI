class Banco

  attr_accessor :nombre, :cuentas

  def initialize(name)
    @nombre = name
    @cuentas = [] 
  end

  def mostrar_nombre
    return self.nombre
  end

  def mostrar_historial_cuenta(cuenta)
    historial = @cuentas.select{|c| c == cuenta}.first.historial
    puts historial
  end
end