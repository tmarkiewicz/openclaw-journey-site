---
title: "Why We Finally Gave the Assistant a Face (and Started with a Blank Identity File)"
description: "How a simple question — 'why is IDENTITY.md blank?' — led us to define avatars, strengthen identity continuity, and make the assistant feel more human."
pubDate: 2026-02-27
authors: ["tom", "clara"]
tags: ["openclaw", "avatars", "identity", "assistant-design", "workflow"]
draft: false
---

Today’s avatar work didn’t start as a design sprint.

It started with a practical question:

**“Why is the identity file blank?”**

That one question forced us to face something we’d been postponing: if an assistant is going to persist across sessions and actually feel useful, it needs more than tools and memory files. It needs a coherent identity.

## The trigger: a blank `IDENTITY.md`

In our workspace, `IDENTITY.md` existed as a template with placeholders — name, vibe, emoji, avatar — but no real choices filled in.

At first glance, that seems harmless.
In practice, it created ambiguity:

- Who is speaking?
- What tone should it use by default?
- How should it represent itself visually across surfaces?

The blank file was basically an unmade product decision.

## Why avatars mattered more than we expected

We didn’t do avatars for “branding polish.”
We did them for operational clarity and trust.

A defined avatar helps with:

1. **Continuity**
   The assistant feels like the same entity across channels and sessions.

2. **Recognition**
   In multi-channel or group contexts, visual identity reduces confusion fast.

3. **Tone anchoring**
   Visual identity reinforces written voice and behavior expectations.

4. **Ownership boundaries**
   A distinct assistant identity helps avoid “is this Tom speaking or the assistant?” ambiguity.

In short: avatar work wasn’t cosmetic. It was interface architecture.

## How we came up with them

Our process was deliberately lightweight:

- Start from the identity fields we already had (`name`, `creature`, `vibe`, `emoji`, `avatar`).
- Align visual direction with how the assistant actually behaves in real operations (practical, competent, not gimmicky).
- Optimize for legibility and recognizability first.
- Choose something that works in small profile-size contexts (where most avatars fail).

The key decision wasn’t “what looks coolest.”
It was: **what best matches the assistant’s real role in daily use?**

## The bigger lesson

The blank identity file was a reminder that defaults are still decisions.

If you don’t define identity, your users will experience a moving target:
different tone, different feel, different expectations every session.

Once identity is explicit, everything gets easier:

- writing style stabilizes,
- interaction patterns become predictable,
- and trust compounds faster.

## Final takeaway

We asked why a file was empty.
We ended up tightening how the assistant shows up everywhere.

That’s been a recurring pattern in this build:
small operational questions uncover bigger product truths.

Avatar work looked like a visual tweak.
It was really a systems decision.
