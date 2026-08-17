#!/bin/bash

# =============================================================================
# Остановка Ollama Server
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
load_config

box_border top
box_line "Остановка Ollama Server"
box_border bottom
echo ""

# Проверка установки Ollama
if ! ollama_is_installed; then
    echo "❌ Ollama не установлен"
    echo ""
    echo "💡 Сначала выполните установку:"
    echo "   ./install.sh"
    exit 1
fi

# Проверка сервиса
SERVICE_STATUS=$(ollama_get_status)
if [ "$SERVICE_STATUS" != "started" ] && [ "$SERVICE_STATUS" != "error" ]; then
    echo "ℹ️  Сервер не запущен (статус: $SERVICE_STATUS)"
    exit 0
fi

# Остановка моделей
RUNNING=$(ollama_get_running_models)
if [ -n "$RUNNING" ]; then
    echo "📋 Остановка моделей:"
    for MODEL in $RUNNING; do
        echo "   ⏹️  $MODEL"
        ollama_unload_model "$MODEL"
    done
fi

echo "🛑 Остановка сервиса..."
ollama_stop

echo "✅ Сервер остановлен"
