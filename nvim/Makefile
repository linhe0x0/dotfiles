all: fmt check

fmt:
	@stylua *.lua lua/

check:
	@luacheck $$(find . -type f -name '*.lua') --codes
