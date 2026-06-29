---
name: create-pr
description: Create a new Github Pull Request. Use this skill when user asks to create a new Github Pull Request.
---

Pre-requisites before creating a PR :
* Ensure no sensitive information is present in the code changes (e.g., passwords, API keys, secrets).
* Run terraform fmt, terraform validate to ensure the code is properly formatted and valid.
* Ensure each commit message follows the conventional commit format (e.g., feat: add new feature, fix: fix bug, docs: update documentation).

1. Create a new Github Pull Request for the current branch. The title of the PR comes from `$ARGUMENTS`. If empty, ask the user for the title before proceeding.

2. The PR description should be generated based on the changes in the current branch. If `$ARGUMENTS` contains a description, use it instead.

3. The PR should be created against the default branch of the repository (usually `main` or `master`).

4. After creating the PR, output the URL of the newly created PR.
