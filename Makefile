default: help # Show help for each of the Makefile recipes.

.PHONY: help _help
help: _help
_help: # Show help for each of the Makefile recipes.
	@grep -E '^[a-zA-Z0-9_-]+:' Makefile | sort | grep -v -E '^help:' | sed 's/_help/help/' | while read -r l; do name=$$(echo $$l | cut -f1 -d':' | xargs); desc=$$(echo $$l | grep -oE '#.*' | cut -c2- | xargs); desc=$${desc:-No description}; printf "\033[1;32m%s\033[00m: %s\n" "$$name" "$$desc"; done

install: # Install all supported tools.
	./install.sh

fmt: # Format shell scripts.
	@shfmt -i 2 -ci -w **/*.sh

lint: # Lint shell scripts.
	@shfmt -i 2 -ci -d **/*.sh
