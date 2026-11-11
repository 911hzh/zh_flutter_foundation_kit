.PHONY: analyze test ci format format-check create

# Analyze package source and tests.
analyze:
	flutter analyze lib test --no-fatal-infos --no-fatal-warnings

# Run package tests.
test:
	flutter test

# Local CI shortcut.
ci: format-check analyze test

# dart format
format:
	@echo "✨ 格式化代码..."
	dart format lib/ test/ example/

# Check formatting without modifying files.
format-check:
	@echo "🔍 检查代码格式..."
	dart format --set-exit-if-changed lib/ test/ example/

# Create a new Flutter app from the example template.
#
# Usage examples:
#   make create helloworldProject
#   make create helloworldProject BUNDLE_ID=com.company.helloworld
#   make create helloworldProject OUTPUT=../apps
#   make create helloworldProject BUNDLE_ID=com.company.helloworld OUTPUT=../apps
#
# Defaults:
#   BUNDLE_ID=com.example.<project>
#   OUTPUT=.. (the parent directory of this repository)
create:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Usage: make create <ProjectName> [BUNDLE_ID=com.company.app] [OUTPUT=../apps]"; \
		exit 1; \
	fi
	python3 tool/create_example_project.py $(filter-out $@,$(MAKECMDGOALS)) \
		$(if $(BUNDLE_ID),--bundle-id "$(BUNDLE_ID)") \
		$(if $(OUTPUT),--output "$(OUTPUT)")

%:
	@:
