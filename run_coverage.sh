#!/bin/bash

# Run Flutter tests with coverage
# This script runs all tests and generates coverage reports

set -e

echo "🧪 Running Flutter tests with coverage..."

# Run tests with coverage
flutter test --coverage

echo "✅ Tests completed!"

# Check if lcov is installed for HTML report generation
if command -v lcov &> /dev/null && command -v genhtml &> /dev/null; then
    echo "📊 Generating HTML coverage report..."

    # Remove unnecessary files from coverage
    lcov --remove coverage/lcov.info 'lib/*/*.g.dart' -o coverage/lcov.info --ignore-errors unused

    # Generate HTML report
    genhtml coverage/lcov.info -o coverage/html

    echo "✅ HTML report generated at coverage/html/index.html"

    # Open the report on macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open coverage/html/index.html
    fi
else
    echo "ℹ️  lcov not installed. Skipping HTML report generation."
    echo "   Install with: brew install lcov"
    echo ""
    echo "📄 Coverage data available at: coverage/lcov.info"
fi

echo ""
echo "🎉 Done!"

