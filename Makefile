LIST_ALL_GD_FILES = find . | grep '\.gd$$' | grep -v addons

default:
	@echo read the makefile

complexity_analysis:
	$(LIST_ALL_GD_FILES) | xargs gdradon cc

lint:
	$(LIST_ALL_GD_FILES) | xargs gdlint
