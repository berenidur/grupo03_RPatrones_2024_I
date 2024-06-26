# Grupo 03 - Reconocimiento de Patrones

Este curso tiene por objetivo dar al estudiante una formación básica y sólida en el Machine Learning o Aprendizaje Máquinas. Abordaremos los diferentes tópicos que comprende el Machine Learning tales como: el aprendizaje supervisado, aprendizaje no supervisado y redes neuronales. Asimismo, se desarrollará un proyecto de investigación que esté basado en la aplicación de Machine Learning usando datos biomédicos.

Como estudiantes de ingeniería biomédica, nuestro objetivo es aprender técnicas avanzadas de Machine Learning para poder analizar señales e imágenes médicas. A través del proyecto de investigación, buscamos aplicar estos conocimientos en situaciones reales, explorando cómo el Machine Learning puede mejorar significativamente el diagnóstico y tratamiento de enfermedades en el campo de la ingeniería biomédica.

## Presentación del equipo

| <img src="images/rhuacasi.jpg" width="200" height="200"> | <img src="images/lsandoval.jpg" width="200" height="200"> | <img src="images/dzavaleta.jpg" width="200" height="200"> |
| :---: | :---: | :---:
|Rodolfo Huacasi Turpo<br>([berenidur](https://github.com/berenidur))| Leonardo Sebastián Sandoval Carranza<br>([Leo2209](https://github.com/Leo2209)) | Daniel Zavaleta Guzmán<br>([dzavaleta03](https://github.com/dzavaleta03)) |
| <p align="justify">Estudiante de  noveno ciclo de la carrera de ingeniería biomédica con interés en el área de señales e imágenes médicas.</p> | <p align="justify">Estudiante del noveno ciclo de Ingeniería Biomédica. Interesado principalmente en el área de Señales e imágenes biomédicas e Ingenieria Clinica.</p> | <p align="justify">Estudiante de último año de Ingeniería Biomedica con interés en la Ingeniería Clínica y el análisis de datos en salud.</p> |

## Proyecto de curso

### Descripción del proyecto
El sueño es esencial para la salud física y mental, y su falta se asocia con diversas condiciones médicas. El Patrón Alternante Cíclico (CAP), una característica microestructural del sueño NREM visible en el EEG, refleja la calidad del sueño y está relacionado con varios trastornos del sueño. Sin embargo, su análisis visual es tedioso y propenso a errores. Este estudio presenta un modelo de red neuronal convolucional unidimensional (1-D CNN) combinado con una red de memoria a corto y largo plazo (LSTM y GRU) para la detección automática del CAP. Se utilizaron datos de la base de datos CAP Sleep Database, preprocesados y equilibrados para obtener señales de pacientes sanos y con diferentes patologías del sueño. Este enfoque automatizado ofrece un paso adelante en la implementación clínica de la evaluación del CAP, proporcionando una herramienta potencialmente eficiente y precisa para el diagnóstico de trastornos del sueño.

### Problemática
El CAP refleja de manera precisa la inestabilidad del sueño, no obstante, su análisis no ha sido completamente adoptado en la práctica clínica debido a diversas limitaciones. El actual método gold estándar para la evaluación del CAP es mediante la identificación visual de las fases del CAP por especialistas entrenados, lo cual es tedioso y consume mucho tiempo, y además está sujeto a errores humanos que pueden llevar a una categorización inexacta. Además, la sutileza y complejidad de las señales EEG hacen que sin las herramientas adecuadas, la interpretación no solo sea un desafío, sino también sea susceptible a imprecisiones significativas. Ante estos retos, surge la necesidad de desarrollar métodos automáticos de análisis de EEG que sean eficientes y precisos. En años recientes, el desarrollo de algoritmos y métodos de análisis automático del CAP, al igual que marcadores basados en el CAP, han empezado a facilitar el uso más generalizado del CAP en el diagnóstico de patologías del sueño.

### Objetivos
1. Desarrollar un modelo de red neuronal convolucional unidimensional (1-D CNN) combinado con una red de memoria a corto y largo plazo (LSTM) para la detección automática del CAP.
2. Utilizar datos preprocesados y equilibrados de la base de datos CAP Sleep Database para obtener señales de pacientes sanos y con diferentes patologías del sueño.
3. Evaluar la eficiencia y precisión del modelo propuesto en la implementación clínica de la evaluación del CAP.
4. Proporcionar una herramienta potencialmente eficiente y precisa para el diagnóstico de trastornos del sueño.

### Operacionalización de la variable (target)
Las fases del CAP están compuestas por ciclos alternantes de alta y baja actividad cortical, definidos como fases A y B, respectivamente. Para la operacionalización de la variable objetivo en este proyecto, se consideraron las siguientes características:

- **Fases A y B del CAP**: La fase A consiste en periodos de ondas lentas de alto voltaje junto con ritmos rápidos de baja amplitud, subdivididos en tres subgrupos: A1, A2 y A3. La fase B se define por actividad de bajo voltaje e irregular. Cada ciclo CAP está compuesto por un par de fases A y B, donde cada fase dura entre 2 y 60 segundos.
- **Datos de entrada**: Se utilizaron señales EEG del canal F4-C4 con una frecuencia de muestreo de 512 Hz, divididas en periodos de 2 y 30 segundos.
- **Modelo propuesto**: La arquitectura del modelo incluye una 1-D CNN seguida de una capa LSTM. La salida del modelo fue categorizada en dos clases, correspondientes a las fases A y B del CAP.
- **Métricas de evaluación**: Se emplearon métricas como la exactitud, sensibilidad y la matriz de confusión para evaluar el rendimiento del modelo.