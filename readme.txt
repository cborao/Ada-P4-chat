
				Práctica 4: César Borao Moratinos


* Para una mejor visualización del código, se recomienda poner los tabuladores del editor en 4 espacios.

* La funcion Nick_Hash que utiliza el programa convierte una cadena de caracteres a un entero formado por la suma del valor de cada caracter en la tabla ASCII.
Cabe la posibilidad de que dos nicks acaben teniendo el mismo valor entero aplicando dicha función, sin embargo esta posibilidad es muy remota y considerando nicks "normales" como nombres se minimizan las probabilidades.

* En el código se utiliza el procedimiento Send_To_Readers para enviar mensajes del servidor a los clientes.
Dicho procedimiento tiene un campo llamado "Automatic" que indica si es el propio servidor el que manda el mensaje o lo que hace en reenviar un writer de un escritor.
