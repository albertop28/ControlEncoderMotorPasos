# Controlador de motor a pasos unipolar con encoder de dos señales.
Consta de un lector de dos entradas digitales de un encoder de dos señales (mecánico), que al girar hacia un sentido una señal, llamémosle señal A, se dispara unos instantes antes de la señal B, en otro caso, si se gira en sentido contrario la señal B se dispara instantes antes de la señal B. Estás señales se acondicionan con una implementación de un filtro de 4 flipflops a 583.73 Hz que eliminan ruido que hubiera en la señal.
Además de esto el código tiene implementado 3 sensores de posición pensados en ser:

-1 para señal de posicionamiento intermedio del motor

-2 para señal de límite de carrera para prohibir el giro más allá de cierto punto de prescencia

Además y se tienen 5 leds indicadores que nos ayudan a visualizar el giro del motor y la activación de las bobinas del motor.
Para una referencia más visual a continuación está un link a un video demostrativo del código funcionando:
https://www.youtube.com/watch?v=fx5JQTpT9iA