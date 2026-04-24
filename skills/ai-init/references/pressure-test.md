
# AI Init Pressure Test

Generate a reusable prompt for another AI to review the current work at whatever stage an ai-init project is in.

## Use This To Check

- gray areas that will turn into churn later
- missing requirements or hidden coupling
- prerequisite state or authority that does not exist yet
- weak handoff quality caused by vague file references
- stage-specific risks before the next move

## Workflow

1. Gather the minimum context needed for review:
   - current stage
   - current artifact or decision under review
   - next intended step
   - goal
   - scope and non-scope
   - hard constraints
   - likely affected files
2. Build a file manifest with absolute paths only. For each file, include:
   - exact absolute path
   - file role
   - why it matters
   - authority: `authoritative`, `supporting`, or `planned output`
   - priority: `required` or `optional`
3. Choose the review lens that matches the current stage:
   - discovery: missing requirements, goals, constraints, and scope boundaries
   - design/spec: structure, feasibility, source-of-truth gaps, and impossible prerequisites
   - planning: task sequencing, dependency order, rollback, and verification coverage
   - implementation: hidden coupling, regressions, state transitions, and edge cases
   - testing/review/release: blind spots, missing evidence, operational risks, and unsafe assumptions
4. Read `references/reviewer-prompt-template.md`.
5. Fill the template without collapsing file detail. Never write "relevant files", "the spec file", or "check the docs".
6. Require the external AI to look for:
   - gray areas and unstated assumptions
   - missing state, permissions, identifiers, storage, events, and async control
   - impossible prerequisites vs mere inconvenience
   - scope bloat, sequencing gaps, and ownership ambiguity
   - missing verification, rollback, and operational concerns
   - risks specific to the current stage and the next intended step
7. Require citations using the same exact absolute paths you provided.

## Guardrails

- Do not hand off unlabeled file lists.
- Do not use relative paths when more than one project root or similar filename could exist.
- Distinguish canonical source files from drafts, generated outputs, and intended future files.
- If a file does not exist yet, still provide its intended absolute path and label it `planned output`.
- The external AI should review and challenge; it should not silently continue execution unless you explicitly ask for that.

## Reference

- `references/reviewer-prompt-template.md` — copy and fill this prompt for the external AI review.
