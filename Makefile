.PHONY: analyze test ci

analyze:
	flutter analyze lib test --no-fatal-infos --no-fatal-warnings

test:
	flutter test

ci: analyze test
