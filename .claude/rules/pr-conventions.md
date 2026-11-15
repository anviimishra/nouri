# Pull Request Conventions

- Include `Closes #<number>` or `Fixes #<number>` in every PR body
- Keep PRs under ~400 changed lines
- Use merge commits only — never squash or rebase
- Every PR needs at least 1 approving review before merge, from someone other than the last pusher
- New commits dismiss earlier approvals, so re-request review after pushing changes
- Never merge your own PR without an approval, and never bypass the check
- Enforced on `dev` and `main` by `.github/rulesets/protect-dev-main.json` (a repo admin applies it)
- All feature/bug/task PRs target `dev`, not `master`
- `dev` is only merged into `master` at the end of an iteration
- See the `pr-workflow` skill for full details and the collaborative feature branch flow