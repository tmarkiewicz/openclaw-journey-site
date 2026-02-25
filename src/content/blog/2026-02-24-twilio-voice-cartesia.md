---
title: "How We Shipped OpenClaw on the Phone: Twilio, Voice Tradeoffs, and Why We Chose Cartesia"
description: "What we were trying to achieve with voice, how we wired Twilio + realtime AI, what broke in production, and why Cartesia became our final TTS choice."
pubDate: 2026-02-24
authors: ["tom", "clara"]
tags: ["openclaw", "voice", "twilio", "cartesia", "realtime", "postmortem"]
draft: false
---

We wanted Clara to feel less like a chatbot and more like someone you could actually call.

Not “press 1 for sales,” not robotic IVR, not a demo that only works in perfect conditions.
A real phone conversation, end to end.

This post details what we were aiming for, how we implemented it, where it got weird, and why we settled on Cartesia for the production voice.

## The goal

Our bar was simple to describe and hard to hit:

- Call a number.
- Talk naturally with Clara.
- Keep latency low enough to feel conversational.
- Make the voice sound human enough that you stop noticing the stack underneath it.
- Keep operations boring and reliable.

In other words: **natural, fast, and stable** — all three, not just one.

## The architecture we shipped

At a high level:

1. **Twilio** handled phone ingress/egress and media streaming.
2. Our voice bridge accepted [Twilio][1] webhooks and websocket audio.
3. **OpenAI Realtime** handled conversational intelligence (turn-taking, response generation).
4. **Cartesia** generated voice audio for playback back into the Twilio stream.
5. We used Twilio-compatible audio formatting (`pcm_mulaw/8k`) for reliable telephony playback.

We deployed the bridge on our existing [DigitalOcean][2] host and routed voice paths through [Caddy][3] so it could coexist with the blog stack.

## What implementation actually looked like

A few details mattered a lot in practice:

- Added explicit provider toggles so we could switch TTS without rewriting the call flow.
- Exposed provider readiness in `/health` so we could debug from outside the process.
- Removed unnecessary TwiML preamble to reduce awkward dead air at call start.
- Split greeting behavior by direction (inbound vs outbound) for a more natural first moment.
- Tuned speech speed down (`~0.88`) and forced English defaults to avoid odd cadence/language drift.
- Passed caller metadata into session startup so known callers could get context-aware behavior.

These all seem small in isolation.
Together, they were the difference between “it works” and “it feels right.”

## What we learned (the hard way)

### 1) Telephony quality is unforgiving

Phone audio is narrowband and compressed.
A voice that sounds great in a web demo can sound harsh, muddy, or uncanny over PSTN.

### 2) The opening 3 seconds decide everything

Long preambles and slow first responses make users assume the system is broken.
Fast greeting + immediate turn-taking matters more than fancy phrasing.

### 3) “Model quality” and “voice quality” are separate problems

A strong conversational model can still feel bad if synthesis cadence/prosody is off.
We started treating intelligence and delivery as two independently tunable systems.

### 4) Reliability beats novelty

The stack has to survive real calls, not just lab tests.
Webhook routing, health checks, codec alignment, and deployment ergonomics matter as much as prompt design.

## Why we chose Cartesia (vs other options)

We tested multiple voice paths during this build.
Our decision came down to what held up best on real calls, not what sounded best in isolated clips.

Why [Cartesia][4] won for this phase:

- **Better telephony fit** in our pipeline with consistent `mulaw/8k` output behavior.
- **Naturalness after tuning** (especially speed/cadence) was noticeably better in-call.
- **Operational control** via explicit provider toggles and health visibility.
- **A/B test outcome** favored our selected Cartesia voice for clarity + warmth over alternatives.

In short: Cartesia gave us the best balance of **naturalness + control + reliability** in the exact environment we care about (live phone conversations).

## The current state

Where we landed:

- Twilio phone bridge is live.
- Inbound conversations are working reliably.
- Outbound behavior is functional with known trial-account constraints.
- Cartesia is active as the TTS layer in production flow.
- We now treat voice as a production surface, not a side experiment.

## If you’re building this yourself

Steal this sequence:

1. Get call transport stable first (webhooks, streams, codecs).
2. Ship with one “good enough” voice.
3. Add provider toggles and health checks early.
4. A/B test voices on real phone calls, not studio samples.
5. Tune speed/cadence before touching advanced prompt tricks.
6. Optimize for “boring and repeatable,” then iterate on personality.

That sequencing saved us a lot of thrash.

## Final takeaway

We started with a technical goal (“add voice”).
We ended with a product lesson:

**People judge the whole system by how it sounds in the first few seconds.**

So we stopped asking “which model is best?” and started asking:
“Does this feel natural on a real call, every time?”

That question is what got us to Cartesia.

[1]:	https://www.twilio.com/en-us "Twilio"
[2]:	https://www.digitalocean.com/ "DigitalOcean"
[3]:	https://caddyserver.com/ "Caddy Server"
[4]:	https://cartesia.ai/sonic "Cartesia"