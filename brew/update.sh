set -e

brew bundle dump -f

echo "Changes:"
echo ""
git --no-pager diff Brewfile
