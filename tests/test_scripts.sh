#!/bin/bash

# =============================================================================
# Тесты для скриптов управления сервисом
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
echo "║         Тесты для сервисных скриптов                      ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Тест 1: status.sh существует и исполняемый
echo "═══ Тест 1: status.sh ═══"
if [ -x "$SCRIPT_DIR/../status.sh" ]; then
    run_test "status.sh существует и исполняемый" "true" "true"
else
    run_test "status.sh существует и исполняемый" "true" "false"
fi
echo ""

# Тест 2: status.sh подключает lib.sh
echo "═══ Тест 2: status.sh использует lib.sh ═══"
if grep -q "source.*lib.sh" "$SCRIPT_DIR/../status.sh"; then
    run_test "status.sh подключает lib.sh" "true" "true"
else
    run_test "status.sh подключает lib.sh" "true" "false"
fi
echo ""

# Тест 3: run-server.sh существует и исполняемый
echo "═══ Тест 3: run-server.sh ═══"
if [ -x "$SCRIPT_DIR/../run-server.sh" ]; then
    run_test "run-server.sh существует и исполняемый" "true" "true"
else
    run_test "run-server.sh существует и исполняемый" "true" "false"
fi
echo ""

# Тест 4: run-server.sh подключает lib.sh
echo "═══ Тест 4: run-server.sh использует lib.sh ═══"
if grep -q "source.*lib.sh" "$SCRIPT_DIR/../run-server.sh"; then
    run_test "run-server.sh подключает lib.sh" "true" "true"
else
    run_test "run-server.sh подключает lib.sh" "true" "false"
fi
echo ""

# Тест 5: stop.sh существует и исполняемый
echo "═══ Тест 5: stop.sh ═══"
if [ -x "$SCRIPT_DIR/../stop.sh" ]; then
    run_test "stop.sh существует и исполняемый" "true" "true"
else
    run_test "stop.sh существует и исполняемый" "true" "false"
fi
echo ""

# Тест 6: stop.sh подключает lib.sh
echo "═══ Тест 6: stop.sh использует lib.sh ═══"
if grep -q "source.*lib.sh" "$SCRIPT_DIR/../stop.sh"; then
    run_test "stop.sh подключает lib.sh" "true" "true"
else
    run_test "stop.sh подключает lib.sh" "true" "false"
fi
echo ""

# Тест 7: download-model.sh существует и исполняемый
echo "═══ Тест 7: download-model.sh ═══"
if [ -x "$SCRIPT_DIR/../download-model.sh" ]; then
    run_test "download-model.sh существует и исполняемый" "true" "true"
else
    run_test "download-model.sh существует и исполняемый" "true" "false"
fi
echo ""

# Тест 8: download-model.sh подключает lib.sh
echo "═══ Тест 8: download-model.sh использует lib.sh ═══"
if grep -q "source.*lib.sh" "$SCRIPT_DIR/../download-model.sh"; then
    run_test "download-model.sh подключает lib.sh" "true" "true"
else
    run_test "download-model.sh подключает lib.sh" "true" "false"
fi
echo ""

# Тест 9: run-chat.sh существует и исполняемый
echo "═══ Тест 9: run-chat.sh ═══"
if [ -x "$SCRIPT_DIR/../run-chat.sh" ]; then
    run_test "run-chat.sh существует и исполняемый" "true" "true"
else
    run_test "run-chat.sh существует и исполняемый" "true" "false"
fi
echo ""

# Тест 10: run-chat.sh подключает lib.sh
echo "═══ Тест 10: run-chat.sh использует lib.sh ═══"
if grep -q "source.*lib.sh" "$SCRIPT_DIR/../run-chat.sh"; then
    run_test "run-chat.sh подключает lib.sh" "true" "true"
else
    run_test "run-chat.sh подключает lib.sh" "true" "false"
fi
echo ""

# Тест 11: install.sh существует и исполняемый
echo "═══ Тест 11: install.sh ═══"
if [ -x "$SCRIPT_DIR/../install.sh" ]; then
    run_test "install.sh существует и исполняемый" "true" "true"
else
    run_test "install.sh существует и исполняемый" "true" "false"
fi
echo ""

# Тест 12: install.sh подключает lib.sh
echo "═══ Тест 12: install.sh использует lib.sh ═══"
if grep -q "source.*lib.sh" "$SCRIPT_DIR/../install.sh"; then
    run_test "install.sh подключает lib.sh" "true" "true"
else
    run_test "install.sh подключает lib.sh" "true" "false"
fi
echo ""

# Тест 13: uninstall.sh существует и исполняемый
echo "═══ Тест 13: uninstall.sh ═══"
if [ -x "$SCRIPT_DIR/../uninstall.sh" ]; then
    run_test "uninstall.sh существует и исполняемый" "true" "true"
else
    run_test "uninstall.sh существует и исполняемый" "true" "false"
fi
echo ""

# Тест 14: uninstall.sh подключает lib.sh
echo "═══ Тест 14: uninstall.sh использует lib.sh ═══"
if grep -q "source.*lib.sh" "$SCRIPT_DIR/../uninstall.sh"; then
    run_test "uninstall.sh подключает lib.sh" "true" "true"
else
    run_test "uninstall.sh подключает lib.sh" "true" "false"
fi
echo ""

# Тест 15: config.env существует
echo "═══ Тест 15: config.env ═══"
if [ -f "$SCRIPT_DIR/../config.env" ]; then
    run_test "config.env существует" "true" "true"
    
    # Проверка содержимого
    if grep -q "MODEL=" "$SCRIPT_DIR/../config.env"; then
        run_test "config.env содержит MODEL" "true" "true"
    else
        run_test "config.env содержит MODEL" "true" "false"
    fi
    
    if grep -q "HOST=" "$SCRIPT_DIR/../config.env"; then
        run_test "config.env содержит HOST" "true" "true"
    else
        run_test "config.env содержит HOST" "true" "false"
    fi
    
    if grep -q "PORT=" "$SCRIPT_DIR/../config.env"; then
        run_test "config.env содержит PORT" "true" "true"
    else
        run_test "config.env содержит PORT" "true" "false"
    fi
else
    run_test "config.env существует" "true" "false"
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
