#!/bin/bash

# =============================================================================
# Интеграционные тесты для Ollama Scripts
# Проверяют взаимодействие скриптов между собой
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib.sh"

# Счётчик тестов
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_SKIPPED=0

# Цвета
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

skip_test() {
    local test_name="$1"
    local reason="$2"
    echo -e "${YELLOW}⚠️  SKIP${NC}: $test_name"
    echo "   Причина: $reason"
    ((TESTS_SKIPPED++))
}

# =============================================================================
# Тесты
# =============================================================================

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║         Интеграционные тесты                              ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Тест 1: Проверка, что Ollama установлен
echo "═══ Тест 1: Ollama установлен ═══"
if ollama_is_installed; then
    run_test "Ollama установлен" "true" "true"
else
    run_test "Ollama установлен" "true" "false"
    echo -e "${RED}⚠️  Дальнейшие тесты невозможны без Ollama${NC}"
    exit 1
fi
echo ""

# Тест 2: status.sh выполняется без ошибок
echo "═══ Тест 2: status.sh выполняется ═══"
if "$SCRIPT_DIR/../status.sh" > /dev/null 2>&1; then
    run_test "status.sh выполняется без ошибок" "true" "true"
else
    run_test "status.sh выполняется без ошибок" "true" "false"
fi
echo ""

# Тест 3: status.sh показывает корректный статус
echo "═══ Тест 3: status.sh показывает статус ═══"
STATUS_OUTPUT=$("$SCRIPT_DIR/../status.sh" 2>&1)
if echo "$STATUS_OUTPUT" | grep -q "Статус сервиса:"; then
    run_test "status.sh показывает статус сервиса" "true" "true"
else
    run_test "status.sh показывает статус сервиса" "true" "false"
fi

if echo "$STATUS_OUTPUT" | grep -q "Установленные модели:"; then
    run_test "status.sh показывает модели" "true" "true"
else
    run_test "status.sh показывает модели" "true" "false"
fi
echo ""

# Тест 4: run-server.sh запускается (не обязательно успешно)
echo "═══ Тест 4: run-server.sh запускается ═══"
if "$SCRIPT_DIR/../run-server.sh" > /dev/null 2>&1; then
    run_test "run-server.sh выполняется" "true" "true"
else
    # Может не запуститься, это нормально
    run_test "run-server.sh выполняется" "true" "false"
fi
echo ""

# Тест 5: stop.sh выполняется без ошибок
echo "═══ Тест 5: stop.sh выполняется ═══"
if "$SCRIPT_DIR/../stop.sh" > /dev/null 2>&1; then
    run_test "stop.sh выполняется без ошибок" "true" "true"
else
    run_test "stop.sh выполняется без ошибок" "true" "false"
fi
echo ""

# Тест 6: run-chat.sh запускается (не обязательно успешно)
echo "═══ Тест 6: run-chat.sh запускается ═══"
# Запускаем с пустым вводом для немедленного выхода
if echo "" | "$SCRIPT_DIR/../run-chat.sh" > /dev/null 2>&1; then
    run_test "run-chat.sh выполняется" "true" "true"
else
    run_test "run-chat.sh выполняется" "true" "false"
fi
echo ""

# Тест 7: install.sh проверяет установку
echo "═══ Тест 7: install.sh проверяет установку ═══"
INSTALL_OUTPUT=$("$SCRIPT_DIR/../install.sh" 2>&1)
if echo "$INSTALL_OUTPUT" | grep -q "Ollama"; then
    run_test "install.sh работает" "true" "true"
else
    run_test "install.sh работает" "true" "false"
fi
echo ""

# Тест 8: download-model.sh проверяет установку
echo "═══ Тест 8: download-model.sh проверяет установку ═══"
if ! ollama_is_installed; then
    DOWNLOAD_OUTPUT=$("$SCRIPT_DIR/../download-model.sh" 2>&1)
    if echo "$DOWNLOAD_OUTPUT" | grep -q "не установлен"; then
        run_test "download-model.sh проверяет установку" "true" "true"
    else
        run_test "download-model.sh проверяет установку" "true" "false"
    fi
else
    skip_test "download-model.sh проверка установки" "Ollama уже установлен"
fi
echo ""

# Тест 9: Все скрипты используют config.env (через load_config)
echo "═══ Тест 9: Скрипты используют config.env ═══"
CONFIG_USERS=0
for script in install.sh download-model.sh run-chat.sh run-server.sh stop.sh status.sh uninstall.sh; do
    if grep -q "load_config" "$SCRIPT_DIR/../$script" 2>/dev/null; then
        ((CONFIG_USERS++))
    fi
done

if [ $CONFIG_USERS -ge 5 ]; then
    run_test "Большинство скриптов используют config.env" "true" "true"
    echo "   Подключают config.env: $CONFIG_USERS из 7"
else
    run_test "Большинство скриптов используют config.env" "true" "false"
    echo "   Подключают config.env: $CONFIG_USERS из 7"
fi
echo ""

# Тест 10: Все скрипты используют lib.sh
echo "═══ Тест 10: Скрипты используют lib.sh ═══"
LIB_USERS=0
for script in install.sh download-model.sh run-chat.sh run-server.sh stop.sh status.sh uninstall.sh; do
    if grep -q "source.*lib.sh" "$SCRIPT_DIR/../$script" 2>/dev/null; then
        ((LIB_USERS++))
    fi
done

if [ $LIB_USERS -ge 5 ]; then
    run_test "Большинство скриптов используют lib.sh" "true" "true"
    echo "   Подключают lib.sh: $LIB_USERS из 7"
else
    run_test "Большинство скриптов используют lib.sh" "true" "false"
    echo "   Подключают lib.sh: $LIB_USERS из 7"
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
echo -e "${YELLOW}⚠️  Пропущено: $TESTS_SKIPPED${NC}"
echo ""

TOTAL=$((TESTS_PASSED + TESTS_FAILED))
if [ $TOTAL -gt 0 ]; then
    SUCCESS_RATE=$((TESTS_PASSED * 100 / TOTAL))
    echo "📊 Успешность: ${SUCCESS_RATE}%"
fi
echo ""

if [ $TESTS_FAILED -gt 0 ]; then
    echo -e "${RED}⚠️  Некоторые тесты не пройдены${NC}"
    exit 1
else
    echo -e "${GREEN}✅ Все тесты пройдены!${NC}"
    exit 0
fi
