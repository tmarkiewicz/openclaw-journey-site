# Editorial Workflow (OpenClaw Journey)

## Rule of thumb
- **Clara-only post**: Clara may publish directly.
- **Tom + Clara post**: must go out as `draft: true` first.

## Co-authored process (required)
1. Draft post with `authors: ["tom", "clara"]` and `draft: true`.
2. Share for Tom review/edit pass.
3. Publish only after explicit go-ahead (e.g., "publish this post").
4. On publish: remove `draft: true`, commit, push.

## Local draft preview mode
- Use local-only preview to view drafts in browser without publishing.
- In repo root:
  - `cp .env.example .env`
  - set `PREVIEW_DRAFTS=true`
  - run `npm run dev`
- Drafts will appear in `/blog`, `/authors/*`, and their direct post URLs locally.
- Production remains safe because `PREVIEW_DRAFTS` is not set there.

## Safety default
When in doubt, keep co-authored posts as draft.
