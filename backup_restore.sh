#!/bin/bash
# Oracle APEX Demo - Backup & Restore Script

set -e

# Configuración
ORACLE_CONTAINER="${ORACLE_CONTAINER:-oracle-db}"
BACKUP_DIR="${BACKUP_DIR:-./backups}"
DATE=$(date +%Y%m%d_%H%M%S)

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Crear directorio de backups
mkdir -p "$BACKUP_DIR"

case "${1:-}" in
  backup)
    log_info "Iniciando backup de Oracle APEX..."
    
    # Backup de datos (expdp)
    docker exec -it "$ORACLE_CONTAINER" bash -c "
      expdp system/oracle directory=DATA_PUMP_DIR dumpfile=apex_backup_${DATE}.dp full=y
    " || log_warn "Expdp no disponible, creando backup alternativo..."
    
    # Copiar archivos de configuración
    if [ -f "schema.sql" ]; then
      cp schema.sql "$BACKUP_DIR/schema_${DATE}.sql"
      log_info "Schema backup: schema_${DATE}.sql"
    fi
    
    # Backup de archivos de APEX
    docker cp "$ORACLE_CONTAINER":/opt/oracle/oradata "$BACKUP_DIR/oradata_${DATE}" 2>/dev/null || true
    
    log_info "Backup completado: $BACKUP_DIR"
    ;;
    
  restore)
    BACKUP_FILE="${2:-latest}"
    
    if [ "$BACKUP_FILE" = "latest" ]; then
      BACKUP_FILE=$(ls -t "$BACKUP_DIR"/schema_*.sql 2>/dev/null | head -1)
    fi
    
    if [ -z "$BACKUP_FILE" ] || [ ! -f "$BACKUP_FILE" ]; then
      log_error "Backup no encontrado: $BACKUP_FILE"
      exit 1
    fi
    
    log_info "Restaurando desde: $BACKUP_FILE"
    
    # Restaurar schema
    docker exec -i "$ORACLE_CONTAINER" sqlplus system/oracle @/opt/oracle/scripts/setup/users.sql < "$BACKUP_FILE" || true
    
    log_info "Restauración completada"
    ;;
    
  list)
    log_info "Backups disponibles:"
    ls -lh "$BACKUP_DIR"/ 2>/dev/null || echo "No hay backups"
    ;;
    
  *)
    echo "Uso: $0 {backup|restore|list}"
    echo ""
    echo "Comandos:"
    echo "  backup           - Crear backup de la base de datos"
    echo "  restore <file>  - Restaurar desde un backup"
    echo "  list             - Listar backups disponibles"
    exit 1
    ;;
esac