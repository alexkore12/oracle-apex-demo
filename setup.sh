#!/bin/bash
# Oracle APEX Demo - Local Development Setup Script
# Usage: ./setup.sh

set -e

echo "🚀 Setting up Oracle APEX Demo environment..."

# Check for SQLcl or SQL*Plus
if ! command -v sql &> /dev/null; then
    echo "⚠️  SQL client not found. Please install SQLcl or SQL*Plus."
    echo "   Download SQLcl: https://www.oracle.com/database/sqldeveloper/technologies/sqlcl/"
    exit 1
fi

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Default values
CONN_STRING=${CONN_STRING:-"localhost:1521:xe"}
APEX_USER=${APEX_USER:-"APEX"}
APEX_PASS=${APEX_PASS:-""}

echo "📋 Configuration:"
echo "   Connection: $CONN_STRING"
echo ""

# Test connection
echo "🔗 Testing database connection..."
sql -s "$CONN_USER/$CONN_PASS@$CONN_STRING" "SELECT 'Connection successful!' FROM dual;" || {
    echo "❌ Failed to connect to database"
    exit 1
}

echo "✅ Oracle APEX Demo environment ready!"
echo ""
echo "📝 Next steps:"
echo "   1. Create workspace in APEX"
echo "   2. Import schema.sql"
echo "   3. Run application in APEX"