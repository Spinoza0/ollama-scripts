#!/bin/bash

# =============================================================================
# Проверка статуса Ollama
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.env"
source "$SCRIPT_DIR/lib.sh"

box_border top
box_line "Проверка статуса Ollama"
box_border bottom
echo ""

# 1. Проверка установки
echo "📦 Установка Ollama:"
if ollama_is_installed; then
    echo "   ✅ Установлен: $(ollama_get_version)"
else
    echo "   ❌ Не установлен"
    echo ""
    echo "💡 Для установки: ./install.sh"
    exit 1
fi
echo ""

# 2. Проверка сервиса
echo "🚀 Статус сервиса:"
SERVICE_STATUS=$(ollama_get_status)
if [ "$SERVICE_STATUS" = "started" ] || [ "$SERVICE_STATUS" = "error" ]; then
    echo "   ✅ Запущен (статус: $SERVICE_STATUS)"
    echo "   URL: ${API_URL}"

    # Информация о запущенных моделях
    echo ""
    echo "📋 Активные модели в памяти:"
    RUNNING=$(ollama_get_running_models)
    if [ -n "$RUNNING" ]; then
        for MODEL in $RUNNING; do
            echo "   $MODEL"
        done
    else
        echo "   ℹ️  Нет активных моделей"
    fi
else
    echo "   ❌ Не запущен (статус: $SERVICE_STATUS)"
fi
echo ""

# 3. Проверка установленных моделей
echo "📚 Установленные модели:"
MODELS=$(ollama_list_models)
if [ -n "$MODELS" ]; then
    echo "$MODELS" | while read -r line; do
        echo "   $line"
    done
else
    echo "   ℹ️  Нет загруженных моделей"
    echo ""
    echo "💡 Для загрузки: ./download-model.sh"
fi
echo ""

# 4. Информация о конфигурации
echo "⚙️  Конфигурация:"
echo "   Модель по умолчанию: $MODEL"
echo "   Хост: $HOST"
echo "   Порт: $PORT"
echo ""

# 5. Доступные команды
echo "📌 Доступные команды:"
echo "   ./install.sh        - Установить Ollama"
echo "   ./download-model.sh - Загрузить модель"
echo "   ./run-chat.sh       - Режим диалога"
echo "   ./run-server.sh     - Режим сервера"
echo "   ./stop.sh           - Остановить сервер"
echo "   ./uninstall.sh      - Удалить Ollama"
echo ""
