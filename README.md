# Proyect Flutter Events

Hemos empezado por la creación de la Base de Datos y probándola como se detalla que se va a corregir. Una vez hecho esto, crearemos la estructura de carpetas, los modelos de datos y las pantallas, así como un ViewModel general para que los datos que se compartan entra pantallas y los puntos de entrada y salida de la BD estén agrupados.

Hay que recordar, que para que funcione el --delay debemos instalar la versión de json-server@0, por que la @1 (que es la que se instala por defecto si no ponemos número) no permite usar el --delay.

Una vez hemos creado el modelo (evento) y su servicio en el provider (el ViewModel general), que se encargará de filtrar los datos y gestionarse con la BD, nos ponemos con los widgets que ya sabemos que van a necesitar las pantallas, es decir, los eventos y las listas de eventos. Mejor hacer esto ahora, por que ahorra buena cosa de tiempo.

Después nos ponemos con las pantallas, y una vez tenemos su prototipo creado podemos pasar a probar las funcionalidades... acordarse de guardar bien en todas las pestañas por que si no se nos lia el flutter con lo que tiene y no tiene. También aconsejable hacer un flutter clean y un flutter pub get si da errores de caché con el emulador de Windows. Si sigue sin funcionar, asegurate de que la ruta en la que está el proyecto no tiene caractéres especiales (º,¿?,!¡...) o te volverás locuelo intentando hacer que vaya.

Ahora que hemos podido enchufar la aplicación, vemos que tiene ciertos bugs a la hora de reimprimir los cambios... algo falla con los ChangeNotifier(). Toca averiguar por que no se repintant los eventos cuando los filtro... y parece que es que tenia un doble ChangeNotifierProvider.value en event_list.dart, que me daba problemas y además la función getEvents() asignaba events sin aplicar los filtros, así que cuando algo cambiaba no volvía a repintarse. Así pues, arreglamos la función getEvents y llamamos al ChangeNotifier desde el Service en el widget de la lista de eventos... pero sigue sin funcionar. Remirando, he visto que la función toggleFavorite no actualiza el evento en la lista events (solo el objeto en si), así que lo modifico para que busque el evento en la lista principal y actualice el estado en ella también.

Todo lo anterior no acabó de funcionar, así que probé a mirar el applyFilters para que siempre partiera de events y a darle a los bools un inicio (en vez de que empezaran en null, que empezaran en false) y con esto se arregló el bug 🥳. Quiero pensar que todo lo anterior también fue necesario. También eliminé en este momento una barra de búsqueda y un botón de actualizar que no venían al caso, pero que estaban muy bien puestos en el proyecto de ejemplo.

Una vez hecho esto pasé a la configuración de los campos requeridos y las "reglas del negocio" (que la descripción fuera opcional, la largaria del título, que solo se pudiera marcar una fecha posterior...) y me salió otro bug, cuando seleccionaba una foto del local no la ponía (Aunque se guardaba el evento correctamente en la db, yuhuuu!). Este era fácil, resulta que mi ImagePicker pensaba que la ruta que le pasábamos era de red, y por eso fallaba. Le arreglé los ifs y listo.

Pero mirando como se me habían creado los nuevos eventos, me di cuenta de que había estado guardando en el jsonServer y en local el isFavorite🤦🏽 Pero bueno, simplemente con cambiar en el modelo de eventos el ToJson se corregía el problema, ya no se guardaba en el server. En el proceso me di cuenta de que los eventos de hoy mismo no los considera próximos... pero no me arriesgué a tocarlo, por que igualmente funciona. Hoy ya no es el futuro.

Haciendo pruebas me di cuenta de que mi EditPage no volvía a la lista, si no al detalle del evento... así que corregí esto con popUntil. Una vez ya tenía toda la estructura hecha, arreglé visualmente la app, que estaba toda manga por hombro en cuanto a los espacios y al diseño responsive y di por concluido el trabajo.




