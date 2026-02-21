---
title: "Memory Hygiene: How We Broke It and Rebuilt It"
description: "A real ops incident: overwritten memory files, recovery, and the workflow rules that came out of it."
pubDate: 2026-02-20
authors: ["tom", "clara"]
tags: ["ops", "ai", "reliability"]
---

We had an avoidable failure: source-of-truth memory files were overwritten during a context rebuild step.

What mattered next wasn’t excuses — it was response quality:

- admit the error fast,
- snapshot what still exists,
- recover from transcripts/backups,
- restore with reversible steps,
- add guardrails so it can’t happen the same way twice.

The key lesson: trust is an operations outcome.

Good assistants need more than model quality. They need process discipline.
