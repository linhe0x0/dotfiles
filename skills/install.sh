#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [[ "${TRACE-0}" == "1" ]]; then
  set -o xtrace
fi

cd "$(dirname "$0")"

# source utils
source "../utils.sh"

# Install Agent Skills
install_skills() {
  install "skills"

  skills add https://github.com/obra/superpowers --global --yes \
    --skill brainstorming \
    --skill systematic-debugging \
    --skill writing-plans \
    --skill executing-plans \
    --skill test-driven-development \
    --skill verification-before-completion \
    --skill receiving-code-review \
    --skill subagent-driven-development \
    --agent claude-code \
    --agent opencode

  skills add https://github.com/mattpocock/skills --global --yes \
    --skill grill-me \
    --skill write-a-prd \
    --agent claude-code \
    --agent opencode

  skills add https://github.com/vercel-labs/agent-browser --global --yes \
    --skill agent-browser \
    --skill electron \
    --agent claude-code \
    --agent opencode

  skills add https://github.com/vercel-labs/agent-skills --global --yes \
    --skill vercel-react-best-practices \
    --skill vercel-composition-patterns \
    --skill vercel-react-view-transitions \
    --agent claude-code \
    --agent opencode

  skills add https://github.com/anthropics/skills --global --yes \
    --skill skill-creator \
    --agent claude-code \
    --agent opencode

  skills add https://github.com/github/awesome-copilot --global --yes \
    --skill documentation-writer \
    --agent claude-code \
    --agent opencode

  skills add https://github.com/pbakaus/impeccable --global --yes \
    --agent claude-code \
    --agent opencode

  skills add https://github.com/remotion-dev/skills --global --yes \
    --skill remotion-best-practices \
    --agent claude-code \
    --agent opencode

  skills add https://github.com/nextlevelbuilder/ui-ux-pro-max-skill --global --yes \
    --skill ui-ux-pro-max \
    --agent claude-code \
    --agent opencode

  skills add https://github.com/supabase/agent-skills --global --yes \
    --skill supabase-postgres-best-practices \
    --agent claude-code \
    --agent opencode

  skills add https://github.com/kepano/obsidian-skills --global --yes \
    --skill obsidian-markdown \
    --agent claude-code \
    --agent opencode

  skills add https://github.com/garrytan/gstack --global --yes \
    --skill gstack \
    --agent claude-code \
    --agent opencode

  skills ls -g

  ok "skills"
}

install_skills
