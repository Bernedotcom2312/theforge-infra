---
name: create-module
description: Create a new Terraform module. Use this skill when user asks to create a new Terraform module with a standard file structure.
---

Create a new Terraform module scaffold. The module name comes from `$ARGUMENTS` (kebab-case). If empty, ask the user for the name before proceeding.

Create the directory `modules/<name>/` with exactly these five files:

**`modules/<name>/main.tf`**

**`modules/<name>/variables.tf`**

**`modules/<name>/outputs.tf`**

**`modules/<name>/README.md`**

Check https://registry.terraform.io/ to fill those files with the appropriate content for a Terraform module.

You must use the latest version for the given provider if appropriate, pin the exact version (wildcard versions are not allowed). 
Enrich the `README.md` with a description of the module, usage instructions, and examples.

Do not add any other files or directories beyond these five.

After creating the files, list them with their relative paths, then remind the user to:
- Ensure every variable in `variables.tf` has both `description` and `type` set.
