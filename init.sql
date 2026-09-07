-- ============================================
-- Esquema de Base de Datos: Dashboard Asistencia IT
-- Compatible con PostgreSQL (Neon.tech)
-- ============================================

-- Tabla principal de KPIs (lo que consume la API)
CREATE TABLE IF NOT EXISTS kpis (
    id SERIAL PRIMARY KEY,
    total_empleados INTEGER NOT NULL,
    asistencia_promedio NUMERIC(5,2) NOT NULL,
    empleados_bajo_60 INTEGER NOT NULL,
    area_critica VARCHAR(50) NOT NULL,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar datos de prueba del proyecto CUGDL (Abril 2026)
INSERT INTO kpis (total_empleados, asistencia_promedio, empleados_bajo_60, area_critica)
VALUES (100, 86.8, 14, 'IT Support')
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- Tabla opcional: Detalle de empleados (para futuras consultas)
-- ============================================
CREATE TABLE IF NOT EXISTS empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    area VARCHAR(50) NOT NULL,
    dias_laborables INTEGER NOT NULL,
    dias_asistidos INTEGER NOT NULL,
    dias_remotos INTEGER NOT NULL,
    dias_permiso INTEGER NOT NULL,
    vacaciones_disponibles INTEGER NOT NULL,
    fecha_expiracion_vacaciones DATE,
    estatus VARCHAR(20) NOT NULL,
    porcentaje_asistencia NUMERIC(5,2) GENERATED ALWAYS AS (
        CASE 
            WHEN dias_laborables > 0 
            THEN ((dias_asistidos + dias_remotos)::NUMERIC / dias_laborables * 100)
            ELSE 0
        END
    ) STORED,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices para optimizar consultas frecuentes
CREATE INDEX IF NOT EXISTS idx_empleados_area ON empleados(area);
CREATE INDEX IF NOT EXISTS idx_empleados_estatus ON empleados(estatus);
CREATE INDEX IF NOT EXISTS idx_empleados_porcentaje ON empleados(porcentaje_asistencia);

-- ============================================
-- Datos de ejemplo: 14 empleados bajo 60% de asistencia
-- (Extraídos del análisis del CUGDL)
-- ============================================
INSERT INTO empleados (nombre, area, dias_laborables, dias_asistidos, dias_remotos, dias_permiso, vacaciones_disponibles, fecha_expiracion_vacaciones, estatus)
VALUES 
    ('Diego Romero', 'IT Support', 22, 9, 0, 0, 5, '2026-12-31', 'Activo'),
    ('Gabriela Romero', 'IT Support', 22, 10, 0, 0, 8, '2026-11-15', 'Activo'),
    ('Mariana Salas', 'DevOps', 22, 10, 0, 0, 0, NULL, 'Activo'),
    ('Carlos Salas', 'IT Support', 22, 10, 0, 7, 10, '2026-10-20', 'Permiso'),
    ('Daniel Garcia', 'Security', 22, 10, 0, 7, 12, '2026-09-30', 'Permiso'),
    ('Ana Ramos', 'Networking', 22, 10, 0, 7, 6, '2026-08-15', 'Permiso'),
    ('Juan Diaz', 'Security', 22, 11, 0, 0, 14, '2026-07-20', 'Vacaciones'),
    ('Ana Salas', 'IT Support', 22, 11, 0, 0, 15, '2026-05-19', 'Vacaciones'),
    ('Ricardo Lopez', 'Security', 22, 12, 0, 0, 9, '2026-06-30', 'Vacaciones'),
    ('Andrea Cruz', 'IT Support', 22, 12, 0, 0, 7, '2026-12-15', 'Vacaciones'),
    ('Laura Mendoza', 'Networking', 22, 12, 0, 0, 11, '2026-11-30', 'Vacaciones'),
    ('Hugo Vega', 'DevOps', 22, 13, 0, 7, 8, '2026-05-12', 'Permiso'),
    ('Diego Ruiz', 'DevOps', 22, 13, 0, 7, 5, '2026-10-10', 'Permiso'),
    ('Laura Pineda', 'DevOps', 22, 13, 0, 0, 4, '2026-09-25', 'Vacaciones')
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- Vista útil: Resumen por área
-- ============================================
CREATE OR REPLACE VIEW resumen_por_area AS
SELECT 
    area,
    COUNT(*) as total_empleados,
    ROUND(AVG(porcentaje_asistencia), 2) as asistencia_promedio,
    COUNT(CASE WHEN porcentaje_asistencia < 60 THEN 1 END) as empleados_bajo_60,
    COUNT(CASE WHEN estatus = 'Activo' THEN 1 END) as activos,
    COUNT(CASE WHEN estatus = 'Permiso' THEN 1 END) as en_permiso,
    COUNT(CASE WHEN estatus = 'Vacaciones' THEN 1 END) as en_vacaciones
FROM empleados
GROUP BY area
ORDER BY asistencia_promedio ASC;

-- ============================================
-- Comentarios de documentación
-- ============================================
COMMENT ON TABLE kpis IS 'KPIs principales del dashboard de asistencia IT';
COMMENT ON TABLE empleados IS 'Detalle de los 100 colaboradores del departamento IT';
COMMENT ON COLUMN empleados.porcentaje_asistencia IS 'Campo calculado automáticamente: (dias_asistidos + dias_remotos) / dias_laborables * 100';
COMMENT ON VIEW resumen_por_area IS 'Vista que agrega métricas clave por área para el dashboard';

