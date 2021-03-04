***********************************************************************
*****************************************************************B0g0t2020******
*****************NOTAS PLSQL*******************************************
***********************************************************************
- %ISOPEN: Devuelve "true" si el cursor está abierto.
- %FOUND: Devuelve "true" si el registro fue satisfactoriamente procesado.
- %NOTFOUND: Devuelve "true" si el registro no pudo ser procesado. Normalmente esto ocurre cuando ya se han procesado todos los registros devueltos por el cursor.
- %ROWCOUNT: Devuelve el número de registros que han sido procesados hasta ese momento

******************--INICIO----La función NVL de Oracle-----------------------------------------------------------
La función NVL en Oracle nos permite obtener un valor concreto en vez de NULL como resultado.

Esta función evalúa una columna o expresión de la siguiente manera:

Si no es NULL, devuelve dicho valor.
Si es NULL, devuelve el valor alternativo que le indicamos.

SINTAXIS
NVL(expresión,resultado_si_null)

El tipo de dato del resultado de la «expresión» y «resultado_si_null» tienen que ser compatibles.

EJEMPLO
select
  nombre,
  dni,
  nvl(deportefavorito,'Sin deporte favorito')
from  usuarios;

En este ejemplo estamos seleccionando el nombre, el dni y el deporte favorito de la tabla de usuarios.

Si un usuario tiene valor NULL en el campo «deportefavorito» en el resultado de la consulta, aparecerá la cadena «Sin deporte favorito».
******************---FIN---La función NVL de Oracle-----------------------------------------------------------