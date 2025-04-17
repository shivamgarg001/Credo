#!/bin/bash

echo "Removing all print/debugPrint/assert statements from lib/..."

find ./lib -type f -name "*.dart" -print0 | while IFS= read -r -d '' file; do
  sed -i.bak -E '/^\s*(print|debugPrint|assert)\s*\(.*\);/d' "$file"
  rm "${file}.bak"
done

echo "✅ All debug logs removed!"
