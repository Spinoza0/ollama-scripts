#!/bin/bash

# =============================================================================
# Проверка статуса Ollama
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
load_config

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
    echo "💡 Для установки: $(cmd_name install)"
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
if [ "$SERVICE_STATUS" = "started" ] || [ "$SERVICE_STATUS" = "error" ]; then
    MODELS=$(ollama_list_models)
    if [ -n "$MODELS" ]; then
        echo "$MODELS" | while read -r line; do
            echo "   $line"
        done
    else
        echo "   ℹ️  Нет загруженных моделей"
        echo ""
        echo "💡 Для загрузки: $(cmd_name download-model)"
    fi
else
    OFFLINE=$(ollama_list_models_storage)
    if [ -n "$OFFLINE" ]; then
        echo "   ℹ️  Сервер не запущен — показываю из хранилища:"
        echo "$OFFLINE" | while read -r line; do
            echo "   $line"
        done
        echo ""
        echo "💡 Запустите сервер: $(cmd_name run-server)"
    else
        echo "   ℹ️  Нет загруженных моделей"
        echo ""
        echo "💡 Для загрузки: $(cmd_name download-model)"
    fi
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
printf "   %-22s - %s\n" "$(cmd_name install)" "Установить Ollama"
printf "   %-22s - %s\n" "$(cmd_name download-model)" "Загрузить модель"
printf "   %-22s - %s\n" "$(cmd_name run-chat)" "Режим диалога"
printf "   %-22s - %s\n" "$(cmd_name run-server)" "Режим сервера"
printf "   %-22s - %s\n" "$(cmd_name stop)" "Остановить сервер"
printf "   %-22s - %s\n" "$(cmd_name uninstall)" "Удалить Ollama"
echo ""
