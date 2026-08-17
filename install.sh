#!/bin/bash

# =============================================================================
# Установка Ollama (macOS + Homebrew)
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

box_border top
box_line "Установка Ollama"
box_border bottom
echo ""

# Проверка macOS
if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "❌ Этот скрипт только для macOS"
    exit 1
fi

# Проверка Homebrew
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew не найден"
    echo "   Установите: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

# Проверка, установлен ли уже
if ollama_is_installed; then
    echo "✅ Ollama уже установлен"
    echo "   Версия: $(ollama_get_version)"
else
    echo "📦 Установка Ollama..."
    brew install ollama
    
    if ollama_is_installed; then
        echo "   ✅ Успешно установлено"
    else
        echo "   ❌ Ошибка установки"
        exit 1
    fi
fi

echo ""
box_border top
box_line "Ollama установлен!"
box_border bottom
echo ""
echo "📌 Следующий шаг — загрузка модели:"
echo "   ./download-model.sh"
echo ""
echo "📚 Другие команды:"
echo "   ./run-chat.sh    - Режим диалога"
echo "   ./run-server.sh  - Режим сервера"
echo "   ./stop.sh        - Остановить сервер"
echo "   ./uninstall.sh   - Удалить Ollama"
echo ""
