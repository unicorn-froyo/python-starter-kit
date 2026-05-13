SRC_FILES := $(shell find src -type f -name '*.py')
BUILD_INPUTS := pyproject.toml README.md LICENSE .python-version Makefile $(SRC_FILES)
BUILD_STAMP := dist/.build.stamp
TEST_INPUTS := pyproject.toml Makefile $(SRC_FILES)
TEST_STAMP := dist/.test.stamp
LINT_STAMP := dist/.lint.stamp
FORMAT_STAMP := dist/.format.stamp
TYPECHECK_STAMP := dist/.typecheck.stamp
CHECK_STAMP := dist/.check.stamp

.PHONY: build check test lint format-check typecheck clean

build: $(BUILD_STAMP)

$(BUILD_STAMP): $(CHECK_STAMP) $(BUILD_INPUTS)
	uv build
	@touch $@

check: $(CHECK_STAMP)

$(CHECK_STAMP): $(TEST_STAMP) $(LINT_STAMP) $(FORMAT_STAMP) $(TYPECHECK_STAMP)
	@mkdir -p $(@D)
	@touch $@

test: $(TEST_STAMP)

$(TEST_STAMP): $(TEST_INPUTS)
	uv run coverage run -m unittest discover -s src -p '*_test.py'
	uv run coverage report -m
	@mkdir -p $(@D)
	@touch $@

lint: $(LINT_STAMP)

$(LINT_STAMP): $(TEST_INPUTS)
	uv run ruff check src
	@mkdir -p $(@D)
	@touch $@

format-check: $(FORMAT_STAMP)

$(FORMAT_STAMP): $(TEST_INPUTS)
	uv run ruff format --check src
	@mkdir -p $(@D)
	@touch $@

typecheck: $(TYPECHECK_STAMP)

$(TYPECHECK_STAMP): $(TEST_INPUTS)
	uv run pyright
	@mkdir -p $(@D)
	@touch $@

clean:
	rm -rf dist/
