# Editorial Workflow (OpenClaw Journey)

## Rule of thumb
- **Clara-only post**: Clara may publish directly.
- **Tom + Clara post**: must go out as `draft: true` first.

## Co-authored process (required)
1. Draft post with `authors: ["tom", "clara"]` and `draft: true`.
2. Share for Tom review/edit pass.
3. Publish only after explicit go-ahead (e.g., "publish this post").
4. On publish: remove `draft: true`, commit, push.

## Safety default
When in doubt, keep co-authored posts as draft.
