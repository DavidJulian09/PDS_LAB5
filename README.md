# PDS_LAB5
Para la práctica número 5 de laboratorio se tuvo como  como objetivo la toma y análisis de una señal de electrocardiograma (EKG) junto con el sensor AD8232 , el cual se tomo por medio de electrodos, para ser posteriormente analisados en el programa ( Matlab) gracias a la conexión serial de la tarjeta de procesamiento stm32 y la programación en el programa keil por medio de timers y conversiones análogo digitales ,  la toma de la señal se hizo en un  tiempo de 5 minutos cuyos datos fueron tomados y guardados a partir de la programación y gráfica canción  en matlab  , dichos datos a su vez seran posteriormente analisados por medio de un código de phyton que nos brindara información sobre la transformada de wavelet la cual se utiliza en en procesamientos de señales biológicas para así eliminar ruidos y artefactos o las interferencias captadas  durante el laboratorio producidos por el dispositivo de la capata de señal dicho lo anterior se explicará más a fondo.
# Fisiologia del laboratorio

### A. Actividad simpática y parasimpática del sistema nervioso autónomo

El sistema nervioso autónomo (SNA) es el encargado de la regulación de las funciones involuntarias del cuerpo, esta tiene dos sistemas importantes.

A) Simpático: este es el sistema el cual se actua por situaciones de estrés o emergencia o mejor conocido como("respuesta de lucha o huida"). Este sistema al activarse actua aumentando la frecuencia cardíaca, dilata las pupilas, reduce la actividad digestiva, entre otros efectos.

B) Parasimpático: este sistema es el que se relaja o permite el descanso y la digestión ya que este disminuye la frecuencia cardíaca, contrae las pupilas y estimula la digestión este se conoce como el sistema de ("respuesta de reposo y digestión").

### B. Efecto de la actividad simpática y parasimpática en la frecuencia cardíaca
Simpático: Aumenta la frecuencia cardíaca al liberar noradrenalina, que actúa sobre los receptores beta-adrenérgicos del corazón.

Parasimpático: Disminuye la frecuencia cardíaca mediante la liberación de acetilcolina sobre receptores muscarínicos, principalmente a través del nervio vago

### C. variabilidad de la frecuencia cardiaca (HVR)
La HRV se entiende como la variación en el tiempo entre los latidos consecutivos del corazón, los cuales son medidos como intervalos R-R en un electrocardiograma (ECG).
Se considera un indicador de la regulación autónoma del corazón de las cuales parten dos 
Alta HRV: buen equilibrio autónomo y mayor predominancia parasimpática.
Baja HRV: estrés, fatiga o predominancia simpática.

-LF (Low Frequency): 0.04 – 0.15 Hz → asociado a actividad simpática y parasimpática.

-HF (High Frequency): 0.15 – 0.4 Hz → refleja actividad parasimpática (respiratoria).

-LF/HF Ratio: se usa como indicador del balance simpático-parasimpático.

### D. Transformada de wevelet 
la transformada wavelet es una herramienta matemática para descomponer una señal en componentes de tiempo y frecuencia simultáneamente. A diferencia de la transformada de Fourier, permite análisis multiresolución (alta resolución temporal para frecuencias altas y alta resolución frecuencial para frecuencias bajas).

Usos en señales biológicas:

-Análisis de señales no estacionarias, como ECG, EEG o HRV.

-Detección de eventos transitorios, picos, cambios de frecuencia.

-Estimación del contenido espectral en diferentes momentos.

### E.Esquema 
![Captura de pantalla 2025-04-30 183340](https://github.com/user-attachments/assets/20cb900e-df05-44a8-84e1-0154f4d90854)

# 2. Conversión Análogo-Digital

![Image](Imagenes/PuertosSTM.png)


## A. Incluison de librerias 
    #include "main.h"
    #include "usb_device.h"
    #include "usbd_cdc_if.h"
    #include <stdio.h>
    #include <string.h>
    
En esta sección, se importan las librerías necesarias para el procesamiento de señales, específicamente las siguientes dos son funamentales: usb_device.h la cual nos permite la inicialización y manejo general de la USB y usbd_cdc_if.h la cual nos da la interfaz para la comunicación tipo CDC (puerto serie virtual), las cuales son una base para que la STM32 se comunique con el computador por USB como si fuera un cable serial.

## B. Declaración de variable
    uint32_t Conversor[2] = {0, 0};
    
Esta variable esta declarada para un arreglo de dos enteros de 32 bits sin signo, donde esta recibiendo datos del ADC (conversor análogo digital) y el Conversor [0] es el que se usa en la transmisión USB.

## C. Bucle principal y transmisión USB

    while (1)
    {
    uint8_t resultado;
    sprintf(datos, "%lu\r\n", Conversor[0]);
    do {
    resultado = CDC_Transmit_FS((uint8_t*)datos, strlen(datos));
    } while (resultado == USBD_BUSY);
    HAL_Delay(1);
    }

Este es el bucle principal del programa el cual se ejecuta indefinidamente y su función es leer un valor y convertirlo en texto y enviarlo al computador a través del puerto USB como si fuera un puerto COM virtual, tenemos la variable: uint8_t resultado; la cual almacena el estado de la transmisión, esta se utiliza para comprobar si el buffer está disponible (USBD_OK) o está ocupado (USBD_BUSY) y también encontramos un conversor:  sprintf(datos, "%lu\r\n", Conversor[0]); el cual convierte el valor numérico de Conversor[0] a texto, %lu indica que es un entero largo sin signo (uint32_t), \r\n agrega un salto de línea para que en el monitor serial los valores aparezcan en líneas separadas y por ultimo los datos debe estar definidos previamente como: char datos[64]; o similar.

## D. Transmisión segura por USB
    do {
    resultado = CDC_Transmit_FS((uint8_t*)datos, strlen(datos));
    } while (resultado == USBD_BUSY);
    
Este envía datos usando CDC_Transmit_FS(), si el buffer USB esta ocupado lo reintenta hasta que el envió sea exitoso, otra parte importante es que nos asegura que no se pierda información si el canal esta temporalmente ocupado, por otra parte tenemos la función CDC_Transmit_FS() la cual detiene el ciclo por un milisegundo y evita saturar el puerto USB enviando datos sin pausa por lo cual el sistema funciona de forma estable y controlada. 

## E. Directorios de codigo en keil para cable de comunicación serial
    usbd_cdc__if.h
    usbd_cdc__if.c
    
Estos archivos son parte del middleware USB generado automáticamente por STM32CubeMX cuando activa la clase CDC en el stack USB del microcontrolador, se permite implementar la comunicación por USB como si fuera un puerto serial (COM) entre la STM32 y el computador.
-	usbd_cdc_if.h: este archivo de cabecera. Define las funciones y variables que se pueden usar desde otros archivos del proyecto.
-	usbd_cdc_if.c: este archivo contiene la implementación real del comportamiento del CDC, es decir, lo que ocurre cuando se transmite o recibe algo por USB.
# 2. MATLAB

## A. Configuración inicial
    puertoserial = 'COM3'; 
    frecuencia = 9600; 
    duration = 350;       
    outputFile = 'señal_ECG.csv';

En esta sección encontramos cuatro variables las cuales nos permiten personalizar el código fácilmente sin tener que modificar otras partes, la primera de ellas es el puertoserial el cual define a donde esta conectado el microcontrolador en este caso COM3, la segunda es frecuencia donde debe coincidir con la que se configuro en el arduino, la tercera es duration lo que hace referencia a la duración de la adquisición en segundos en este caso 350 segundos y la ultima de ellas es outputFile la cual permite nombrar el archivo donde se guardan los datos.

## B. Conexión al dispositivo e inicialización
    s = serialport(puertoserial, frecuencia);
    configureTerminator(s, "LF");

    timeVec = [];
    signalVec = [];
Esta parte abre la comunicación con el microcontrolador y prepara los vectores donde se almacenará la señal adquirida, se establece la conexión serial donde se usa el puerto y la frecuencia que se configuro antes (puertoserial, frecuencia) y configureTerminator indica que cada dato termina con un salto de línea (\n), como suele enviarse desde Arduino con Serial.println() y pora completar se utilizan dos variables para guardar los datos timeVec para almacenar los tiempos de cada muestra y signalVec para almacenar los voltajes convertidos desde el ADC.
    
## C. Preparación de la gráfica
    figure('Name', 'ECG', 'NumberTitle', 'off');
    h = plot(NaN, NaN);
    xlabel('Tiempo (s)');
    ylabel('Voltaje (V)');
    title('Señal EMG en Tiempo Real');
    xlim([0, 25]);
    ylim([0, 3.3]);
    grid on;
En esta parte, el código abre una figura en MATLAB para mostrar la señal a medida que se recibe. Se grafica el voltaje en función del tiempo usando un gráfico que se actualiza continuamente. Cada nuevo dato recibido se convierte en voltaje, se añade a los vectores de tiempo y señal, y luego se actualiza el gráfico con los nuevos datos. Además, el eje X se ajusta dinámicamente para mostrar los últimos segundos, creando un efecto de desplazamiento de la señal en tiempo real.

## D. Bucle de adquisición
    startTime = datetime('now');
    while seconds(datetime('now') - startTime) < duration
Este bloque controla la duración total del proceso de adquisición de datos. Una vez transcurrido el tiempo especificado, el ciclo while termina, y el programa continúa con el guardado de datos y cierre del puerto.

    if s.NumBytesAvailable > 0
    datos = readline(s);
    valor = str2double(datos);
    voltage = (valor*3.3)/4095;
    segundos = seconds(datetime('now') - startTime);
Para esta parte se utilizó readline(s) la cual lee una línea desde el puerto, también se utilizo str2double(datos el cual convierte el valor leído a número y por ultimo se convierte el valor digital a voltaje por medio de la siguiente ecuacion: v= valor* 3.3/4095.  
Asume un ADC de 12 bits (2¹² = 4096 valores → de 0 a 4095).

    if ~isnan(voltage)
    timeVec = [timeVec; segundos];
    signalVec = [signalVec; voltage];
Este bloque protege la integridad de los datos adquiridos, asegurando que solo se almacenen valores numéricos válidos y descartando lecturas erróneas o incompletas provenientes del microcontrolador, se utilizo isnan(voltage) para verifica si el valor de voltaje no es un número válido (NaN significa "Not a Number") y isnan(voltage): verifica si el valor de voltaje no es un número válido (NaN significa "Not a Number") y  el símbolo ~ es una negación. Entonces esta condición solo se cumple si el voltaje sí es un número válido.isnan(...): el símbolo ~ es una negación. Entonces esta condición solo se cumple si el voltaje sí es un número válido.

     idx = timeVec >= (segundos-60);
    set(h, 'XData', timeVec, 'YData', signalVec);
    xlim([max(0, segundos - 15), max(15, segundos)])
    drawnow;
La variable idx se define pero no se usa se puedes eliminar o usar si se quiere mostrar solo una ventana móvil de los últimos segundos, se utilizo drawnow actualiza la figura y xlim desplaza el eje X para mostrar los últimos segundos en pantalla.

## E. Guardado de datos
    T = table(timeVec, signalVec, 'VariableNames', {'Tiempo (s)', 'Voltaje (V)'});
    writetable(T, outputFile);
    
En esta parte se permite conservar los datos registrados durante la adquisición para su análisis posterior, organiza la información de forma clara, con nombres de columnas entendibles y facilita la exportación de resultados para informes o gráficos en otros entornos.

## F. limpieza
    clear s
esta parte es muy importante para terminar la parte de MATLAB donde elimina el objeto s para cerrar correctamente la conexión serial.


# 3. programacion de python 





# 4. Analisis de graficas de python 


    
