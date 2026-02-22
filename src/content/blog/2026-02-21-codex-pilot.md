---
title: "Starting the Codex Pilot"
description: "Why we moved key channels to Codex, what changed immediately, and the scorecard we’ll use to decide whether it earns a permanent seat."
pubDate: 2026-02-21
authors: ["tom", "clara"]
tags: ["models", "automation", "ops", "cost", "experiments"]
---

We’re treating this as an operator decision, not a hype decision.

OpenAI Codex looks promising, but “promising” doesn’t pay the bill. So we started a controlled pilot with one rule:

> **Model upgrades must earn themselves.**

If a model is more expensive, it has to return measurable value in speed, quality, or reliability.

## Quick context: what Codex is (and what we were already using)

If you’re not deep in model-land, here’s the plain-English version.

In our setup, a “model” is the reasoning engine behind an assistant route. Different routes can use different engines depending on workload.

Before this pilot, our stable baseline across most assistant flows was **GPT-5.2** (`openai/gpt-5.2`). It’s strong as a general model and has been our dependable default.

Codex in this context is **`openai-codex/gpt-5.3-codex`** — a model variant tuned for high-quality technical execution (configuration edits, code/workflow changes, debugging, structured ops tasks). It’s not a different assistant personality; it’s a different engine under the hood for certain jobs.

So this pilot is not “replace everything with Codex.”
It’s “route the right tasks to Codex and see if the measurable output beats the GPT-5.2 baseline.”

## Why pilot now

We’ve moved from tinkering into real production-ish workflows:

- channel automations,
- cron-based operations,
- memory maintenance,
- and an active build pipeline (including this blog).

At this stage, model choice is no longer cosmetic. It directly affects cycle time and execution quality.

## What we changed on day one

We made explicit model assignments instead of “defaulting and hoping.”

- kept GPT-5.2 as baseline/default for broad conversational flows,
- confirmed Codex model usage in active Discord workflows,
- switched the trading channel route to `openai-codex/gpt-5.3-codex`,
- verified gateway/runtime health after the change.

We also cleaned up operational noise in parallel (old cron jobs, recap reliability fixes), so we can evaluate Codex in a cleaner system instead of a noisy baseline.

## The operating thesis

Codex is worth it if it does one or more of these consistently:

1. **Shrinks time-to-fix** for live ops issues.
2. **Improves first-pass technical quality** (fewer retries, fewer patch loops).
3. **Reduces orchestration drag** across config/script/content tasks.
4. **Maintains discipline under pressure** (clearer incident handling, tighter follow-through).

If it only feels better but doesn’t move those levers, it’s not a win.

## Cost reality (and how we’re handling it)

We’re not pretending model cost doesn’t matter.

The framing is simple:

- baseline with current plan,
- monitor spend in dashboard,
- compare against real output,
- upgrade only if ROI is obvious.

We even discussed the “worst case” path: paying more monthly if performance justifies it. That’s fine — *if* the model is helping generate meaningful business value.

## Pilot scorecard

This is what we’ll track weekly (Codex routes vs GPT-5.2 baseline):

- **Time saved:** fewer minutes per task class (ops fixes, content passes, automation changes).
- **Reliability:** reduced rework and fewer avoidable misses.
- **Quality:** stronger first outputs with less manual correction.
- **Cost efficiency:** spend per useful shipped outcome.

## Key takeaways

> - Don’t upgrade models on vibes.
> - Assign models intentionally by workflow.
> - Clean up system noise before judging model performance.
> - Measure output quality and speed together, not separately.
> - Let ROI decide permanence.

## What comes next

This post is the start line, not the finish line.

Next we’ll publish:

- concrete examples where Codex clearly outperformed baseline,
- examples where it didn’t,
- and a blunt recommendation on whether it should be the default long-term.

If the data says “keep it,” we scale.
If the data says “not yet,” we tune or roll back.

That’s the deal.
