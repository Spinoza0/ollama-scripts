#!/bin/bash

# =============================================================================
# Запуск Ollama Server
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.env"
source "$SCRIPT_DIR/lib.sh"

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║         Запуск Ollama Server                              ║"
echo "║         Хост: $HOST                                       ║"
echo "║         Порт: $PORT                                       ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Проверка установки Ollama
if ! ollama_is_installed; then
    echo "❌ Ollama не установлен"
    echo ""
    echo "💡 Сначала выполните установку:"
    echo "   ./install.sh"
    exit 1
fi

# Проверка, запущен ли уже
SERVICE_STATUS=$(ollama_get_status)
if [ "$SERVICE_STATUS" = "started" ] || [ "$SERVICE_STATUS" = "error" ]; then
    echo "✅ Сервер уже запущен на ${API_URL}"
    echo "   Статус: $SERVICE_STATUS"
    exit 0
fi

echo "🚀 Запуск через brew services..."

if ! ollama_start_and_wait 10; then
    echo "❌ Не удалось запустить сервер"
    exit 1
fi

echo ""
echo "✅ Сервер запущен на ${API_URL}"
echo "📌 Для остановки: ./stop.sh"
