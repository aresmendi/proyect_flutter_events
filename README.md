# Proyect Flutter Events

Hemos empezado por la creación de la Base de Datos y probándola como se detalla que se va a corregir. Una vez hecho esto, crearemos la estructura de carpetas, los modelos de datos y las pantallas, así como un ViewModel general para que los datos que se compartan entra pantallas y los puntos de entrada y salida de la BD estén agrupados.

Hay que recordar, que para que funcione el --delay debemos instalar la versión de json-server@0, por que la @1 (que es la que se instala por defecto si no ponemos número) no permite usar el --delay.

Una vez hemos creado el modelo (evento) y su servicio en el provider (el ViewModel general), que se encargará de filtrar los datos y gestionarse con la BD, nos ponemos con los widgets que ya sabemos que van a necesitar las pantallas, es decir, los eventos y las listas de eventos. Mejor hacer esto ahora, por que ahorra buena cosa de tiempo.

Después nos ponemos con las pantallas, y una vez tenemos su prototipo creado podemos pasar a probarlas... acordarse de guardar bien en todas las pestañas por que si no se nos lia el flutter con lo que tiene y no tiene. También aconsejable hacer un flutter clean y un flutter pub get si da errores de caché con el emulador de Windows. Si sigue sin funcionar, asegurate de que la ruta en la que está el proyecto no tiene caractéres especiales (º,¿?,!¡...) o te volverás locuelo intentando hacer que vaya.

Ahora que hemos podido enchufar la aplicación, vemos que tiene ciertos bugs a la hora de reimprimir los cambios... algo falla con los ChangeNotifier(). Toca averiguar que es.