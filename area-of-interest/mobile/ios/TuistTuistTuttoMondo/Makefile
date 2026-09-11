TUIST := mise exec -- tuist
SCHEME := TuistTuistTuttoMondo
FOCUS_TARGET := GreetingKit
GRAPH_OUTPUT_DIR := /tmp/TuistTuistTuttoMondo-graph
GRAPH_FORMAT ?= svg

.DEFAULT_GOAL := help

.PHONY: help version edit generate generate-open test focus graph graph-dot

help: ## Show the available commands
	@printf '%s\n' \
		'make version        Verify the repository-pinned Tuist version' \
		'make edit           Open the manifest-editing project' \
		'make generate       Generate the complete project without opening it' \
		'make generate-open  Generate and open the complete project' \
		'make test           Run every test in the shared scheme' \
		'make focus          Generate a project focused on GreetingKit' \
		'make graph          Generate an SVG dependency graph under /tmp' \
		'make graph-dot      Print dependency edges in the terminal'

version: ## Verify the repository-pinned Tuist version
	$(TUIST) version

edit: ## Open the manifest-editing project
	$(TUIST) edit

generate: ## Generate the complete project without opening it
	$(TUIST) generate run --no-open

generate-open: ## Generate and open the complete project
	$(TUIST) generate run

test: ## Run every test in the shared scheme
	$(TUIST) test run $(SCHEME) --no-selective-testing

focus: ## Generate a project focused on GreetingKit
	$(TUIST) generate run $(FOCUS_TARGET) --no-open

graph: ## Generate the dependency graph under /tmp (GRAPH_FORMAT=svg by default)
	mkdir -p $(GRAPH_OUTPUT_DIR)
	$(TUIST) graph --format $(GRAPH_FORMAT) --output-path $(GRAPH_OUTPUT_DIR) --no-open

graph-dot: ## Generate DOT and print its dependency edges
	$(MAKE) graph GRAPH_FORMAT=dot
	@rg -- '->' $(GRAPH_OUTPUT_DIR)
