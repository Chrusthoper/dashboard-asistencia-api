from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import psycopg2
import os
from dotenv import load_dotenv

# Carga las variables del archivo .env
load_dotenv()

# Inicializa la app
app = FastAPI(title="API Dashboard Asistencia IT", version="1.0.0")

# CORS: Permite que tu HTML en Cloudflare Pages hable con esta API
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Funcion para conectar a PostgreSQL
def get_db():
    conn = psycopg2.connect(os.getenv("DATABASE_URL"))
    return conn

# Endpoint principal: cuando el HTML haga GET /api/asistencia
@app.get("/api/asistencia")
def obtener_asistencia():
    try:
        conn = get_db()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT total_empleados, asistencia_promedio, 
                   empleados_bajo_60, area_critica 
            FROM kpis LIMIT 1
        """)
        row = cursor.fetchone()
        conn.close()

        if row:
            return {
                "total_empleados": row[0],
                "asistencia_promedio": row[1],
                "empleados_bajo_60": row[2],
                "area_critica": row[3]
            }
        else:
            return {"mensaje": "No hay datos aun"}

    except Exception as e:
        # Si la base de datos no existe o falla, devuelve datos de prueba
        return {
            "mensaje": "Datos de prueba (DB no conectada)",
            "total_empleados": 100,
            "asistencia_promedio": 86.8,
            "empleados_bajo_60": 14,
            "area_critica": "IT Support"
        }

# Endpoint de salud: para que Render sepa que la app esta viva
@app.get("/health")
def health():
    return {"status": "ok"}
