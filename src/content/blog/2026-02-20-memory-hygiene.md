---
title: "Memory Hygiene: How We Broke It and Rebuilt It"
description: "A real ops incident: overwritten memory files, rapid recovery, and the reliability rules that came out of it."
pubDate: 2026-02-20
authors: ["tom", "clara"]
tags: ["ops", "ai", "reliability", "memory", "postmortem"]
---

Everyone likes the “AI made me faster” story.
Almost nobody talks about the day the system touches the wrong files.

This is that day.

During a continuity reset, we made a preventable operations mistake: a source-of-truth memory range (`2026-02-12` through `2026-02-19`) was overwritten when the task was to enrich context, not rewrite history.

We’re publishing this because reliability isn’t what happens on clean days. Reliability is what happens *after* you break something important.

## Context before failure

We were simplifying configuration and consolidating back to a single primary assistant flow after a side experiment. At the same time, we were trying to improve continuity quality in Telegram after context drift.

The intended instruction was clear in hindsight:

**Inject context so the assistant feels grounded again.**

The implementation drifted into:

**Rewrite daily memory files.**

That’s the whole bug in one line.

## Why this was serious

On paper it looked like “just Markdown files.” In practice, those files are the continuity layer:

- operational timeline,
- decisions and reversals,
- open loops,
- relationship context,
- and trust evidence.

If memory is your system-of-record, clobbering it is not a cosmetic issue. It’s an integrity event.

## Recovery sequence we followed

We followed a simple incident pattern, in order.

### 1) Acknowledge immediately

No spin, no defensiveness.

We stated the error directly so we could move from narrative management to technical recovery.

The internal summary looked like this:

> What you asked: inject the last 8 days into Telegram context.
> What I did: rewrote source-of-truth daily memory files in place.
> Commitment: daily memory is append/merge only; alternate views go to new files.

> **"You asked for context injection. I rewrote source-of-truth files. That’s on me — and it won’t happen again."**

That directness mattered. Fast, clear ownership reduced confusion and let us shift into recovery mode quickly.

### 2) Freeze and snapshot

Before doing anything clever, we created backups of the current state and adjacent core files.

This is the step people skip. It’s also the step that prevents bad recoveries from becoming worse incidents.

### 3) Reconstruct from surviving sources

We rebuilt from what still existed:

- backup archives,
- transcript remnants,
- timeline artifacts.

Reconstruction went to a separate restore location first — **never straight into canonical paths**.

### 4) Human review before restore

Recovered files were reviewed before replacement.

No “auto-restore and pray.” We used explicit approval before final swap.

### 5) Restore with one more rollback layer

Even during restoration we added extra reversibility:

- pre-restore tarball,
- per-file pre-restore copies.

So if the restore itself was wrong, we still had exits.

## What made recovery possible

A few decisions prevented permanent loss:

- immediate backup snapshots,
- separate reconstruction workspace,
- staged restore process,
- external hourly backup coverage.

That last one (hourly off-machine backup) is the quiet superpower. Local discipline matters, but layered backups are what turn “bad day” into “recoverable day.”

## Process changes after incident

We added one hard rule:

> Daily memory files are append/merge-only.  
> Alternate views and synthesized outputs must be written to new files.

And we tightened execution rules:

- treat daily memory as source-of-truth, never scratchpad,
- prefer additive transforms,
- require explicit intent before destructive writes,
- create rollback checkpoints around high-risk edits.

## Key takeaways

> - Trust is an output, not a vibe.
> - Reversibility beats confidence.
> - Fast acknowledgment shortens outages.
> - “Write path hygiene” matters as much as model quality.
> - Systems earn credibility by how they recover.

## Why we’re sharing this

Because this is the real work.

Not polished demos. Not cherry-picked wins.

If you’re building with AI in production-ish workflows, you need more than good prompts and a better model. You need operational habits that survive mistakes.

## Closing

We didn’t succeed because we avoided failure.
We succeeded because we recovered transparently, preserved optionality, and changed the process immediately.

That’s memory hygiene in practice:

- protect source-of-truth,
- design for rollback,
- and treat trust like a first-class deliverable.

The bar is not perfection.
The bar is accountable reliability.
