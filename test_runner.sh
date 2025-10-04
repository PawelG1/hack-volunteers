#!/bin/bash

# Kolory dla outputu
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   HackVolunteers - Test Runner                ║${NC}"
echo -e "${BLUE}║   Anti-Duplication Test Suite                 ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""

# Funkcja do uruchamiania testów
run_tests() {
    local test_path=$1
    local test_name=$2
    
    echo -e "${YELLOW}📋 Running: ${test_name}${NC}"
    echo ""
    
    if flutter test "$test_path" --reporter expanded; then
        echo -e "${GREEN}✅ ${test_name} - PASSED${NC}"
        echo ""
        return 0
    else
        echo -e "${RED}❌ ${test_name} - FAILED${NC}"
        echo ""
        return 1
    fi
}

# Liczniki
total=0
passed=0
failed=0

# Uruchom testy BLoC
if [ -z "$1" ] || [ "$1" == "bloc" ] || [ "$1" == "all" ]; then
    total=$((total + 1))
    if run_tests "test/features/events/presentation/bloc/events_bloc_duplication_test.dart" "EventsBloc Duplication Tests"; then
        passed=$((passed + 1))
    else
        failed=$((failed + 1))
    fi
fi

# Uruchom testy Widget
if [ -z "$1" ] || [ "$1" == "widget" ] || [ "$1" == "all" ]; then
    total=$((total + 1))
    if run_tests "test/features/events/presentation/widgets/swipeable_card_test.dart" "SwipeableCard Widget Tests"; then
        passed=$((passed + 1))
    else
        failed=$((failed + 1))
    fi
fi

# Podsumowanie
echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   TEST SUMMARY                                 ║${NC}"
echo -e "${BLUE}╠════════════════════════════════════════════════╣${NC}"
echo -e "${BLUE}║${NC} Total:   ${total} test suite(s)                       ${BLUE}║${NC}"
echo -e "${BLUE}║${NC} Passed:  ${GREEN}${passed}${NC} ✅                                   ${BLUE}║${NC}"
echo -e "${BLUE}║${NC} Failed:  ${RED}${failed}${NC} ❌                                   ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""

if [ $failed -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed! Anti-duplication protection is working correctly.${NC}"
    exit 0
else
    echo -e "${RED}⚠️  Some tests failed. Please review the output above.${NC}"
    exit 1
fi
