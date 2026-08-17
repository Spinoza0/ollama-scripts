#!/bin/bash

# =============================================================================
# Полное удаление Ollama (macOS + Homebrew, без sudo)
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
load_config

box_border top
box_line "Удаление Ollama и всех моделей"
box_border bottom
echo ""

# Проверка macOS
if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "❌ Этот скрипт только для macOS"
    exit 1
fi

echo "⚠️  Будет удалено:"
echo "   • Все модели Ollama"
echo "   • Конфигурация и кэши"
echo "   • Приложение Ollama"
echo ""
read -p "Продолжить? (y/N): " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "❌ Отменено"
    exit 0
fi

echo ""
echo "🛑 Остановка сервиса..."
ollama_stop

echo ""
echo "📋 Удаление моделей..."
ollama_rm_all_models
echo "   ✅ Все модели удалены"

echo ""
echo "🗑️  Удаление Ollama..."
brew uninstall ollama

echo ""
echo "🧹 Очистка данных..."
rm -rf ~/.ollama
rm -rf "$HOME/Library/Application Support/Ollama"
rm -rf "$HOME/Library/Caches/Ollama"
rm -rf "$HOME/Library/Logs/Ollama"

echo ""
box_border top
box_line "Удаление завершено!"
box_border bottom
echo ""
echo "💡 Для установки: $(cmd_name install)"
echo ""
