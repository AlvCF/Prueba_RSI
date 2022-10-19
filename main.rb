require_relative "./clases/banco"
require_relative "./clases/cuenta"


banco_primero = Banco.new("Palencia")

banco_segundo = Banco.new("La caja")

cuenta_uno_uno = Cuenta.new("Jim Sinclair", banco_primero)
cuenta_uno_dos = Cuenta.new("James Cameron", banco_primero)

cuenta_dos_uno = Cuenta.new("Emma Smith", banco_segundo)
cuenta_dos_dos = Cuenta.new("Steven Spielberg", banco_segundo)

cuenta_uno_dos.añadir_dinero(50000)
cuenta_uno_dos.transferencia_interna(cuenta_uno_uno, 30000)

cuenta_uno_uno.agente_de_transferencia(cuenta_dos_uno, 20000)

banco_primero.mostrar_historial_cuenta(cuenta_uno_uno)


