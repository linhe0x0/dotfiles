set -e

brew bundle dump --force

echo "Changes:"
echo ""
git --no-pager diff Brewfile
