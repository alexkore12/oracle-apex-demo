# Oracle APEX Demo - Deployment Guide

## Quick Start

### Local Development

```bash
# Using Docker
docker-compose up -d

# Access APEX at http://localhost:8080
# Workspace: DEMO
# Username: demo
# Password: demo123
```

### Production Deployment

1. Oracle Database 19c+
2. Oracle APEX 23.1+
3. Configure SSL/TLS
4. Set up ORDS (Oracle Rest Data Services)

## Configuration

Environment variables:
- `DB_HOST` - Database server
- `DB_PORT` - Database port (default: 1521)
- `DB_SERVICE` - Service name
- `APEX_PORT` - Application port

## Backup

See `docs/backup.md` for backup procedures.

## Security

- Change default passwords
- Enable SSL
- Configure firewall rules
- Regular security updates

