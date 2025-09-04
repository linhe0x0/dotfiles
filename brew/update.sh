set -e

brew bundle dump --describe --force

echo "Changes:"
echo ""
git --no-pager diff Brewfile
