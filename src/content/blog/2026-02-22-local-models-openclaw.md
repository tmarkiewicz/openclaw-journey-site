---
title: "We Tried Local Models in OpenClaw. It Wasn’t Ready for Prime Time (Yet)"
description: "Why our Ollama-in-OpenClaw test failed in practice, what we learned, and when local models still make sense."
pubDate: 2026-02-22
authors: ["tom", "clara"]
tags: ["openclaw", "local-models", "ollama", "ops", "postmortem"]
draft: true
---

After publishing our Codex pilot notes, we wanted to be equally honest about the other side of the experiment:

We also tried to run local models through OpenClaw for agent routing, and it did **not** go smoothly.

This post is that field report.

## Why we wanted local models

The motivation was strong:

- lower variable model cost,
- more control over where inference runs,
- less dependence on external provider availability,
- and freedom to experiment with personality-specialized local models.

On paper, this looked like an obvious win.

## The test setup (high level)

We were trying to route a Telegram agent flow to a local Ollama-backed model via OpenClaw’s provider routing.

Specifically, we tested switching with a command path and expected traffic to hit the local provider.

Instead, routing repeatedly failed at gateway validation.

## What failed in practice

The recurring blocker was not model quality — it was integration plumbing.

Main symptom:

- Gateway repeatedly reported: **“No API key found for provider ollama-local.”**

But this was a local model path, so a traditional remote API key wasn’t conceptually part of the plan.

Additional friction:

- OpenClaw expected an auth profile store at `~/.openclaw/agents/main/agent/auth-profiles.json`.
- That file didn’t exist in the live path we were inspecting.
- We added a dummy provider key in config and restarted; the same auth failure persisted.

So the issue wasn’t “we forgot one obvious setting.”
It looked like a deeper mismatch between expected auth/profile resolution and local-provider routing behavior.

## What we tried

We took pragmatic ops steps:

- inspected config and auth-store paths,
- searched for missing profile files,
- patched provider config with dummy auth placeholders,
- restarted and re-tested with logs,
- considered isolation patterns to keep experiments from polluting production channels.

The result: still unstable for our intended production flow.

## Why this matters

A lot of local-model tutorials stop at: “model is running on localhost.”

Real agent deployment adds another layer:

- orchestration gateway expectations,
- provider-level auth/profile validation,
- multi-session routing semantics,
- and compatibility between command-level model switching and runtime policy.

That last mile is where many “works on my machine” setups break.

## Decision we made

For now, we’re using hosted models for production reliability and using local-model paths as a controlled R&D stream.

That means:

- **production:** proven routes with predictable behavior,
- **experimental:** local models in isolated test loops until routing/auth behavior is deterministic.

It’s less romantic than “all local now,” but it’s operationally sane.

## Key takeaways

> - Local inference being up is not the same as agent routing being production-ready.
> - Auth/profile expectations can block “local-only” workflows.
> - Gateway integration details matter more than benchmark scores.
> - Isolate experiments from primary channels until behavior is deterministic.
> - Reliability first; ideology second.

## Where we go next

We’re not abandoning local models.
We’re sequencing them correctly.

Next pass is to validate a clean, reproducible local-provider path in a non-critical route, document exact config requirements, and only then promote to production.

If we can make it boring and repeatable, we’ll ship it.
If not, we keep it in the lab.

That’s the standard now: useful > clever.
