# 📱 Project Flutter Events

Aplicación desarrollada en Flutter para la gestión de eventos, utilizando una arquitectura organizada con Provider para la gestión del estado y json-server como backend simulado.

---

## 📌 Descripción General

Este proyecto consiste en una aplicación de gestión de eventos que permite crear, editar, filtrar y administrar eventos de manera dinámica. Se ha desarrollado siguiendo una estructura clara y modular, separando modelos de datos, servicios, gestión del estado y componentes visuales.

La aplicación utiliza:

- **Provider** para la gestión del estado
- **ChangeNotifier** para la actualización reactiva de la interfaz
- **json-server@0** como API REST simulada
- `ImagePicker` para la gestión de imágenes locales

> ⚠️ Importante: Para poder utilizar el parámetro `--delay` en json-server es necesario instalar la versión `0.x`. La versión `1.x` no permite su uso.

---

## 🏗️ Arquitectura del Proyecto

El proyecto sigue una organización estructurada:

### 🔹 Capa de Datos
Backend simulado mediante json-server para realizar operaciones CRUD sobre los eventos.

### 🔹 Modelos
Modelo `Event` con serialización y deserialización adecuadas para la comunicación con la API.

### 🔹 Servicio / ViewModel (Provider)
Capa centralizada encargada de:

- Obtener los eventos
- Aplicar filtros
- Gestionar favoritos
- Notificar cambios a la interfaz
- Coordinar la comunicación con la base de datos

### 🔹 Widgets Reutilizables
Componentes personalizados para:

- Tarjetas de eventos
- Listas de eventos
- Elementos comunes de interfaz

### 🔹 Pantallas
- Listado de eventos
- Detalle de evento
- Creación de evento
- Edición de evento

---

## 🔧 Funcionalidades Implementadas

- Creación, edición y eliminación de eventos
- Marcado y desmarcado de favoritos (gestión local)
- Aplicación dinámica de filtros
- Selección de imágenes desde el dispositivo
- Validación de formularios y reglas de negocio:
  - Título obligatorio
  - Descripción opcional
  - Validación de fecha futura
- Ajustes de diseño responsive
- Control de navegación con `popUntil`

---

## 🐛 Problemas Detectados y Soluciones

Durante el desarrollo se identificaron y corrigieron diversos problemas:

- Duplicidad de `ChangeNotifierProvider` que impedía la correcta actualización del estado.
- Filtros que no provocaban el repintado de la interfaz.
- Método `toggleFavorite` que no actualizaba correctamente la lista principal de eventos.
- Inicialización incorrecta de variables booleanas (valores `null` en lugar de `false`).
- Error en la carga de imágenes por tratar rutas locales como imágenes de red.
- Navegación incorrecta tras la edición de eventos.
- Eliminación de componentes innecesarios (barra de búsqueda y botón de actualización).

Estas mejoras permitieron estabilizar la aplicación y asegurar un comportamiento reactivo coherente.

---

## ⚙️ Notas de Desarrollo

En caso de errores durante la ejecución:

- Ejecutar:
flutter clean
flutter pub get
- Verificar que la ruta del proyecto no contenga caracteres especiales.
- Confirmar que la versión de json-server instalada es la correcta.

---

## 🧠 Resumen

Este proyecto refleja el desarrollo completo de una aplicación Flutter, incluyendo:

- Diseño de arquitectura
- Simulación de backend
- Gestión del estado
- Implementación de reglas de negocio
- Depuración y mejora iterativa
- Ajustes visuales y de navegación

Representa un ciclo completo de desarrollo: desde la configuración inicial hasta la estabilización final de la aplicación.
