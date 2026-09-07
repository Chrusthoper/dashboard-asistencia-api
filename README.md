# Dashboard de Asistencia IT - IT Workforce Intelligence

Sistema completo de visualización y análisis de asistencia para departamentos de TI, diseñado para identificar riesgos operativos, optimizar la cobertura de equipos y prevenir ausentismo crítico.

## Demo en Vivo

**Dashboard:** https://dashboard.ouroboros-ch.com  
**API REST:** https://dashboard-asistencia-api.onrender.com/api/asistencia  
**Documentación API:** https://dashboard-asistencia-api.onrender.com/docs (Swagger UI automático)

---

## Problema que Resuelve

Departamentos de TI con 100+ colaboradores enfrentan tres desafíos críticos:

1. **Visibilidad insuficiente**: No pueden distinguir entre ausencias justificadas (vacaciones, permisos médicos) y ausentismo injustificado que requiere intervención.
2. **Riesgo de cobertura**: Concentraciones de vacaciones/permisos en áreas críticas (como IT Support) pueden dejar al equipo por debajo de la capacidad mínima operativa.
3. **Toma de decisiones reactiva**: Los supervisores actúan cuando el problema ya es visible, no cuando se puede prevenir.

Este dashboard transforma datos crudos de asistencia en **indicadores accionables** que permiten:
- Identificar empleados bajo el umbral del 60% de asistencia con nivel de urgencia.
- Detectar áreas con riesgo estructural (IT Support: 78.7% vs 91.4% de Security).
- Anticipar "bombas de vacaciones" que pueden agravar la capacidad operativa en los próximos 30 días.

---

## Arquitectura del Sistema

**Frontend (Cloudflare Pages)**
- URL: https://dashboard.ouroboros-ch.com
- HTML/CSS/JavaScript vanilla
- Fetch API para consumo de backend
- Dashboard dinámico con 4 roles (CEO, RH, Supervisor, Empleado)

**Backend (Render.com)**
- URL: https://dashboard-asistencia-api.onrender.com
- FastAPI + Python 3.14
- Endpoints REST: /api/asistencia, /health
- CORS configurado para acceso cross-origin

**Base de Datos (Neon.tech)**
- PostgreSQL serverless
- Tabla: kpis (100 empleados, métricas agregadas)
- Esquema: init.sql (versionado en GitHub)

**Control de Versiones (GitHub)**
- Repositorio público con CI/CD automático
- Deploy automático en push a main

---

## Características Principales

### Frontend
- **4 roles con vistas diferenciadas**: CEO (resumen ejecutivo), RH (gestión completa), Supervisor IT (aprobaciones y cobertura), Empleado (perfil y solicitudes).
- **KPIs en tiempo real**: Capacidad operativa, asistencia promedio, empleados en riesgo, área crítica.
- **Tablas interactivas**: Filtros por área y nivel de riesgo, drill-down a detalle de colaboradores.
- **Sistema de solicitudes**: Flujo de aprobación de permisos con máquina de estados (pendiente → supervisor → RH → cerrado).
- **Diseño responsivo**: Optimizado para escritorio y tablet.

### Backend
- **API RESTful**: Endpoints documentados automáticamente con Swagger UI.
- **Conexión a PostgreSQL**: Consultas optimizadas a base de datos en la nube.
- **Manejo de errores**: Try/catch con valores por defecto si la base de datos no está disponible.
- **CORS configurado**: Permite acceso desde el frontend en Cloudflare Pages.

### Base de Datos
- **Esquema relacional**: Tablas kpis (métricas agregadas) y empleados (detalle de colaboradores).
- **Datos de prueba**: 100 empleados distribuidos en 4 áreas (DevOps, IT Support, Networking, Security).
- **Campos calculados**: Porcentaje de asistencia generado automáticamente en PostgreSQL.

---

## Stack Tecnológico

| Capa | Tecnología | Justificación |
|------|------------|---------------|
| Frontend | HTML/CSS/JavaScript vanilla | Cero dependencias, carga instantánea, control total del código |
| Backend | FastAPI + Python | Framework moderno, rápido, con documentación automática |
| Base de Datos | PostgreSQL (Neon.tech) | Serverless, escalable, estándar de la industria |
| Despliegue Frontend | Cloudflare Pages | CDN global, gratis, integración nativa con dominios personalizados |
| Despliegue Backend | Render.com | Deploy automático desde GitHub, tier gratuito suficiente para prototipos |
| Control de Versiones | GitHub | CI/CD automático, historial de cambios, colaboración |
| Dominio | Cloudflare DNS | Gestión centralizada, SSL automático, Zero Trust |

**Alineación con requisitos de FECIAR:**
- Protocolos HTTP (API REST con FastAPI)
- PostgreSQL (base de datos relacional en la nube)
- Dashboards de observabilidad (KPIs en tiempo real)
- JavaScript/HTML (frontend dinámico)
- Infraestructura cloud (Render, Neon, Cloudflare)

---

## Estructura del Proyecto

    dashboard-asistencia-api/
    ├── index.html                      # Frontend: Dashboard completo (HTML/CSS/JS)
    ├── main.py                         # Backend: API REST en FastAPI
    ├── requirements.txt                # Dependencias Python
    ├── render.yaml                     # Configuración de despliegue en Render
    ├── init.sql                        # Esquema de base de datos PostgreSQL
    └── README.md                       # Este archivo

---

## Despliegue Local

Si quieres ejecutar este proyecto en tu máquina:

**1. Clonar el repositorio**

    git clone https://github.com/Chrusthoper/dashboard-asistencia-api.git
    cd dashboard-asistencia-api

**2. Configurar la base de datos**

Crea una base de datos PostgreSQL (local o en Neon.tech) y ejecuta:

    psql -U tu_usuario -d tu_base_de_datos -f init.sql

**3. Configurar variables de entorno**

Crea un archivo .env (no incluido en el repositorio por seguridad):

    DATABASE_URL=postgresql://usuario:contraseña@host:5432/nombre_db

**4. Instalar dependencias**

    pip install -r requirements.txt

**5. Ejecutar el backend**

    uvicorn main:app --host 0.0.0.0 --port 8000

La API estará disponible en http://localhost:8000 con documentación en http://localhost:8000/docs

**6. Abrir el frontend**

Abre index.html en tu navegador. El dashboard cargará los datos desde la API local.

---

## Contexto Académico

Este proyecto surge del análisis de datos realizado para la materia **Visualización de Datos** (CUGDL, Mayo 2026), donde se identificaron patrones críticos en un dataset de 100 colaboradores de TI:

- **Anomalía matemática**: 51 de 100 empleados tenían suma de días que superaba los 22 días laborables del mes (doble conteo o error de captura).
- **Zona crítica estructural**: IT Support con 78.7% de asistencia vs 91.4% de Security (brecha de 13 puntos).
- **Bomba de vacaciones**: 4 empleados con vacaciones por vencer antes del 20 de mayo, incluyendo Ana Salas (IT Support, 15 días, ya bajo 60% de asistencia).

El dashboard transforma estos hallazgos en una herramienta operativa que responde: "¿Qué necesito hacer hoy para que el mes que viene no tenga el mismo problema?"

---

## Próximas Mejoras

- Autenticación real: Sistema de login con JWT (actualmente simulado con selección de rol)
- Persistencia de solicitudes: Conectar el flujo de aprobación de permisos a la base de datos
- Generación automática de datos: Script Python que actualice los KPIs diariamente con datos simulados
- Alertas automáticas: Notificaciones cuando un área supere el 30% de personal ausente
- Integración con LLMs: Asistente de IA para interpretar tendencias y sugerir acciones

---

## Licencia

Este proyecto fue desarrollado como parte de la formación académica en la Licenciatura en Inteligencia Artificial y Ciencia de Datos (CUGDL). El código es de acceso público con fines educativos y de portafolio profesional.

---

## Autor

**Christopher Tavares**  
Estudiante de Inteligencia Artificial y Ciencia de Datos  
Centro Universitario de Guadalajara (CUGDL)  
GitHub: @Chrusthoper

**¿Interesado en colaborar o discutir el proyecto?**  
Abre un issue en este repositorio o contáctame a través de LinkedIn.
