.PHONY: analyze test ci create

# Analyze package source and tests.
analyze:
	flutter analyze lib test --no-fatal-infos --no-fatal-warnings

# Run package tests.
test:
	flutter test

# Local CI shortcut.
ci: analyze test

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
