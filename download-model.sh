#!/bin/bash

# =============================================================================
# Загрузка модели (по умолчанию qwen3.5:9b)
# После загрузки сервис останавливается
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.env"
source "$SCRIPT_DIR/lib.sh"

MODEL="${1:-$MODEL}"

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║         Загрузка модели $MODEL                            ║"
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

# Проверка, был ли сервис запущен до нас
WAS_RUNNING=false
if ollama_is_running; then
    WAS_RUNNING=true
fi

# Запуск сервиса если не запущен
if [ "$WAS_RUNNING" = false ]; then
    echo "⚠️  Сервис не запущен. Временно запускаю..."
    
    if ! ollama_start_and_wait 30; then
        echo "❌ Не удалось запустить сервис"
        exit 1
    fi
    echo "✅ Сервис запущен"
fi

# Проверка, есть ли уже модель
if ollama_model_exists "$MODEL"; then
    echo "✅ Модель $MODEL уже загружена"
else
    echo "⬇️  Загрузка $MODEL (может занять время)..."
    ollama pull "$MODEL"
fi

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║              Модель загружена!                            ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Остановка сервиса если мы его запускали
if [ "$WAS_RUNNING" = false ]; then
    echo "🛑 Остановка сервиса (был запущен только для загрузки)..."

    # Выгрузка моделей из памяти перед остановкой
    RUNNING=$(ollama_get_running_models)
    if [ -n "$RUNNING" ]; then
        for MODEL_NAME in $RUNNING; do
            ollama_unload_model "$MODEL_NAME"
        done
    fi

    ollama_stop
    echo "✅ Сервис остановлен"
else
    echo "ℹ️  Сервис был запущен ранее, оставляем работающим"
fi

echo ""
