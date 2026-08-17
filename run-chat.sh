#!/bin/bash

# =============================================================================
# Запуск Ollama в режиме диалога
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.env"
source "$SCRIPT_DIR/lib.sh"

MODEL="${1:-$MODEL}"

# Проверка установки Ollama
if ! ollama_is_installed; then
    echo "❌ Ollama не установлен"
    echo ""
    echo "💡 Сначала выполните установку:"
    echo "   ./install.sh"
    exit 1
fi

box_border top
box_line "Режим диалога с Ollama"
box_line "Модель: $MODEL"
box_border bottom
echo ""
echo "💬 Диалог. Для выхода: /bye"
echo "═══════════════════════════════════════════════════════════"
echo ""

# Проверка, был ли сервис запущен до нас
WAS_RUNNING=false
if ollama_is_running; then
    WAS_RUNNING=true
fi

# Запуск сервиса если не запущен
if [ "$WAS_RUNNING" = false ]; then
    echo "⚠️  Сервис не запущен. Временно запускаю..."

    if ! ollama_start_and_wait 10; then
        echo "❌ Не удалось запустить сервис"
        exit 1
    fi
    echo "✅ Сервис запущен"
    echo ""
fi

ollama run "$MODEL" --keepalive "$KEEP_ALIVE"

# Остановка сервиса если мы его запускали
if [ "$WAS_RUNNING" = false ]; then
    echo ""
    echo "🛑 Остановка сервиса (был запущен только для диалога)..."
    ollama_stop
    echo "✅ Сервис остановлен"
fi
