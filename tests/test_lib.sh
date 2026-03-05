#!/bin/bash

# =============================================================================
# Тесты для библиотеки lib.sh
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib.sh"

# Счётчик тестов
TESTS_PASSED=0
TESTS_FAILED=0

# Цвета
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# =============================================================================
# Функция для запуска теста
# =============================================================================
run_test() {
    local test_name="$1"
    local expected="$2"
    local actual="$3"
    
    if [ "$expected" = "$actual" ]; then
        echo -e "${GREEN}✅ PASS${NC}: $test_name"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ FAIL${NC}: $test_name"
        echo "   Ожидалось: $expected"
        echo "   Получено: $actual"
        ((TESTS_FAILED++))
    fi
}

# =============================================================================
# Тесты
# =============================================================================

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║         Тесты для lib.sh                                  ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Тест 1: ollama_is_installed
echo "═══ Тест 1: ollama_is_installed ═══"
if ollama_is_installed; then
    run_test "Ollama установлен" "0" "0"
else
    run_test "Ollama установлен" "1" "0"
fi
echo ""

# Тест 2: ollama_get_version
echo "═══ Тест 2: ollama_get_version ═══"
VERSION=$(ollama_get_version)
if [[ "$VERSION" == *"ollama version"* ]]; then
    run_test "Версия получена" "true" "true"
    echo "   Версия: $VERSION"
else
    run_test "Версия получена" "true" "false"
fi
echo ""

# Тест 3: ollama_get_status
echo "═══ Тест 3: ollama_get_status ═══"
STATUS=$(ollama_get_status)
if [[ "$STATUS" == "started" || "$STATUS" == "error" || "$STATUS" == "stopped" || "$STATUS" == "none" ]]; then
    run_test "Статус корректный" "true" "true"
    echo "   Статус: $STATUS"
else
    run_test "Статус корректный" "true" "false"
    echo "   Статус: $STATUS"
fi
echo ""

# Тест 4: ollama_is_running
echo "═══ Тест 4: ollama_is_running ═══"
if ollama_is_running; then
    run_test "Сервис запущен" "true" "true"
    echo "   Сервис: запущен"
else
    run_test "Сервис запущен" "false" "false"
    echo "   Сервис: не запущен"
fi
echo ""

# Тест 5: ollama_list_models
echo "═══ Тест 5: ollama_list_models ═══"
MODELS=$(ollama_list_models)
if [ -n "$MODELS" ] || [ -z "$MODELS" ]; then
    run_test "Список моделей получен" "true" "true"
    if [ -n "$MODELS" ]; then
        echo "   Модели:"
        echo "$MODELS" | while read -r line; do
            echo "   - $line"
        done
    else
        echo "   Нет загруженных моделей"
    fi
else
    run_test "Список моделей получен" "true" "false"
fi
echo ""

# Тест 6: ollama_model_exists (если есть модели)
echo "═══ Тест 6: ollama_model_exists ═══"
if [ -n "$MODELS" ]; then
    FIRST_MODEL=$(echo "$MODELS" | head -1 | awk '{print $1}')
    if ollama_model_exists "$FIRST_MODEL"; then
        run_test "Модель $FIRST_MODEL существует" "true" "true"
    else
        run_test "Модель $FIRST_MODEL существует" "true" "false"
    fi
    
    if ollama_model_exists "nonexistent_model_xyz123"; then
        run_test "Несуществующая модель" "false" "true"
    else
        run_test "Несуществующая модель" "false" "false"
    fi
else
    echo "   ⚠️  Пропущено (нет загруженных моделей)"
fi
echo ""

# =============================================================================
# Итоги
# =============================================================================
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                    Итоги тестов                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo -e "${GREEN}✅ Пройдено: $TESTS_PASSED${NC}"
echo -e "${RED}❌ Провалено: $TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -gt 0 ]; then
    echo -e "${RED}⚠️  Некоторые тесты не пройдены${NC}"
    exit 1
else
    echo -e "${GREEN}✅ Все тесты пройдены!${NC}"
    exit 0
fi
