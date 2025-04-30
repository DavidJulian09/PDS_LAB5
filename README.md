# PDS_LAB5
Para la práctica número 5 de laboratorio se tuvo como  como objetivo la toma y análisis de una señal de electrocardiograma (EKG) junto con el sensor AD8232 , el cual se tomo por medio de electrodos, para ser posteriormente analisados en el programa ( Matlab) gracias a la conexión serial de la tarjeta de procesamiento stm32 y la programación en el programa keil por medio de timers y conversiones análogo digitales ,  la toma de la señal se hizo en un  tiempo de 5 minutos cuyos datos fueron tomados y guardados a partir de la programación y gráfica canción  en matlab  , dichos datos a su vez seran posteriormente analisados por medio de un código de phyton que nos brindara información sobre la transformada de wavelet la cual se utiliza en en procesamientos de señales biológicas para así eliminar ruidos y artefactos o las interferencias captadas  durante el laboratorio producidos por el dispositivo de la capata de señal dicho lo anterior se explicará más a fondo.
## fisiologia del laboratorio
# A. Actividad simpática y parasimpática del sistema nervioso autónomo

El sistema nervioso autónomo (SNA) es el encargado de la regulación de las funciones involuntarias del cuerpo, esta tiene dos sistemas importantes.

A) Simpático: este es el sistema el cual se actua por situaciones de estrés o emergencia o mejor conocido como("respuesta de lucha o huida"). Este sistema al activarse actua aumentando la frecuencia cardíaca, dilata las pupilas, reduce la actividad digestiva, entre otros efectos.

B) Parasimpático: este sistema es el que se relaja o permite el descanso y la digestión ya que este disminuye la frecuencia cardíaca, contrae las pupilas y estimula la digestión este se conoce como el sistema de ("respuesta de reposo y digestión").

# B. Efecto de la actividad simpática y parasimpática en la frecuencia cardíaca
Simpático: Aumenta la frecuencia cardíaca al liberar noradrenalina, que actúa sobre los receptores beta-adrenérgicos del corazón.

Parasimpático: Disminuye la frecuencia cardíaca mediante la liberación de acetilcolina sobre receptores muscarínicos, principalmente a través del nervio vago

# C. variabilidad de la frecuencia cardiaca (HVR)
La HRV se entiende como la variación en el tiempo entre los latidos consecutivos del corazón, los cuales son medidos como intervalos R-R en un electrocardiograma (ECG).
Se considera un indicador de la regulación autónoma del corazón de las cuales parten dos 
Alta HRV: buen equilibrio autónomo y mayor predominancia parasimpática.
Baja HRV: estrés, fatiga o predominancia simpática.

Frecuencias de interés en HRV (análisis espectral):
ULF (Ultra Low Frequency): < 0.003 Hz
VLF (Very Low Frequency): 0.003 – 0.04 Hz
LF (Low Frequency): 0.04 – 0.15 Hz → asociado a actividad simpática y parasimpática.
HF (High Frequency): 0.15 – 0.4 Hz → refleja actividad parasimpática (respiratoria).
LF/HF Ratio: se usa como indicador del balance simpático-parasimpático.
# D. Transformada de wevelet 

# E.



## 2. Conversión Análogo-Digital

![Image](Imagenes/PuertosSTM.png)


# A. Incluison de librerias 
    #include "main.h"
    #include "usb_device.h"
    #include "usbd_cdc_if.h"
    #include <stdio.h>
    #include <string.h>
    
En esta sección, se importan las librerías necesarias para el procesamiento de señales, específicamente las siguientes dos son funamentales: usb_device.h la cual nos permite la inicialización y manejo general de la USB y usbd_cdc_if.h la cual nos da la interfaz para la comunicación tipo CDC (puerto serie virtual), las cuales son una base para que la STM32 se comunique con el computador por USB como si fuera un cable serial.

# B. Declaración de variable
    uint32_t Conversor[2] = {0, 0};
    
Esta variable esta declarada para un arreglo de dos enteros de 32 bits sin signo, donde esta recibiendo datos del ADC (conversor análogo digital) y el Conversor [0] es el que se usa en la transmisión USB.

# C. Bucle principal y transmisión USB

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

# D. Transmisión segura por USB
    do {
    resultado = CDC_Transmit_FS((uint8_t*)datos, strlen(datos));
    } while (resultado == USBD_BUSY);
    
Este envía datos usando CDC_Transmit_FS(), si el buffer USB esta ocupado lo reintenta hasta que el envió sea exitoso, otra parte importante es que nos asegura que no se pierda información si el canal esta temporalmente ocupado, por otra parte tenemos la función CDC_Transmit_FS() la cual detiene el ciclo por un milisegundo y evita saturar el puerto USB enviando datos sin pausa por lo cual el sistema funciona de forma estable y controlada. 

# E. Directorios de codigo en keil para cable de comunicación serial
    usbd_cdc__if.h
    usbd_cdc__if.c
    
Estos archivos son parte del middleware USB generado automáticamente por STM32CubeMX cuando activa la clase CDC en el stack USB del microcontrolador, se permite implementar la comunicación por USB como si fuera un puerto serial (COM) entre la STM32 y el computador.
-	usbd_cdc_if.h: este archivo de cabecera. Define las funciones y variables que se pueden usar desde otros archivos del proyecto.
-	usbd_cdc_if.c: este archivo contiene la implementación real del comportamiento del CDC, es decir, lo que ocurre cuando se transmite o recibe algo por USB.


    
