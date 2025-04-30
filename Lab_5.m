% Configuracion
puertoserial = 'COM3'; %Administrador dispositivos
frecuencia = 9600; 
duration = 350;       % Duración 
outputFile = 'señal_ECG_1.csv';  %Archivo salida

%Leer y conectar puerto serial
s = serialport(puertoserial, frecuencia);
configureTerminator(s, "LF");

%Variables
timeVec = [];  % Vector de tiempo
signalVec = [];  % Vector de señal

%Gráfica
figure('Name', 'ECG', 'NumberTitle', 'off');
h = plot(NaN, NaN);
xlabel('Tiempo (s)');
ylabel('Voltaje (V)');
title('Señal EMG en Tiempo Real');
xlim([0, 25]);
ylim([0, 3.3]);  % Ajusta rango voltaje
grid on;

disp('Iniciando adquisición...');
startTime = datetime('now');

while seconds(datetime('now') - startTime) < duration
    
    if s.NumBytesAvailable > 0
        datos = readline(s);
        valor = str2double(datos);
        voltage = (valor*3.3)/4095;
        segundos = seconds(datetime('now') - startTime);

        if ~isnan(voltage)
             timeVec = [timeVec; segundos];
             signalVec = [signalVec; voltage];
             idx = timeVec >= (segundos-60);
             set(h, 'XData', timeVec, 'YData', signalVec);
             xlim([max(0, segundos - 15), max(15, segundos)])
             drawnow;
        end
    end
end

%Guardar Datos
disp('Adquisición finalizada. Guardando archivo...');
T = table(timeVec, signalVec, 'VariableNames', {'Tiempo (s)', 'Voltaje (V)'});
writetable(T, outputFile);
disp(['Datos guardados en: ', outputFile]);

clear s;