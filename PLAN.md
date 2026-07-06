> **This is a living plan.** Revisions are logged in [CHANGELOG.md](./CHANGELOG.md).
> **Last updated:** 2026-07-06

# 9-Month Mastery Roadmap

**For:** Ravi Kumar Prasad — Senior Product Engineer, targeting Senior/Staff at AI labs and scale-ups
**Cadence:** 12–15 hrs/week (~500 hours total)
**Three tracks, one story:**
1. **ML/AI** — implement transformers from scratch → understand inference engines → build serious agentic systems
2. **System design** — DDIA-level foundations → deep teardowns of AWS, Cloudflare, Railway, Netflix, Uber, Discord, WhatsApp → become "system native"
3. **Rust (primary) + Zig (side-taste)** — real fluency, not tutorial fluency; enough to ship non-trivial systems

**Governing principle:** The three tracks converge. By month 6 you're writing an inference server in Rust that uses paged attention (ML/AI × Rust). By month 8 you're deploying that server multi-region with a documented failover story (all three tracks). By month 9 the capstone is one artifact that demonstrates all three.

---

## Weekly Time Budget

| Track | Hours/week |
|---|---|
| ML/AI (implement-from-scratch + inference + agents) | 5–6 |
| System design (books + teardowns + labs) | 3–4 |
| Rust (theory + projects) | 3–4 |
| Writing / reflection / mocks | 1–2 |

Weeks marked **DEEP** shift the ratio — one track gets the majority of the time. Weeks marked **SYNTH** pull tracks together into a single build.

---

## Phase Overview

| Phase | Weeks | Theme | Capstone at phase end |
|---|---|---|---|
| **0** | 1 | Setup & baseline | Environment, GPU, calendar blocks locked |
| **1** | 2–5 | Foundations across all three | Micrograd + first Rust CLI + DDIA ch 1–5 notes |
| **2** | 6–12 | Building blocks | GPT from scratch + axum HTTP service + Netflix teardown + Cloudflare teardown |
| **3** | 13–19 | Modern architectures | Transformer variants (RoPE, GQA, MoE) + KV store in Rust + AWS/Cloudflare/Railway deep-dive notes + Uber teardown |
| **4** | 20–25 | Inference engines | Read + write about vLLM/llama.cpp; build a small inference server in Rust + Discord + WhatsApp teardowns |
| **5** | 26–32 | Agents at production scale | Multi-agent LangGraph system with evals, safety, tracing, deployed multi-region |
| **6** | 33–36 | Zig taste + portfolio + interview polish | Zig learning + capstone repo + 6 blog posts + recorded talk + resume rewrite |

---

## Phase 0 — Setup (Week 1)

The 30 minutes of setup you don't do in week 1 will cost you 3 hours a week for the next 8 months.

**Environment**
- Local dev box configured for Rust (`rustup`, `cargo`, `rust-analyzer`), Python (uv or pyenv, PyTorch), Docker, kubectl, terraform.
- A GPU story: pick one — Colab Pro ($10/mo, fine for micrograd/tinyGPT), Runpod / Lambda / Modal (pay-as-you-go, better for anything bigger than a toy). Budget $30–50/month for GPU time.
- Public GitHub org/user for the portfolio. One monorepo or many? Pick many — each project should stand alone as an interview artifact.
- A private notes vault (Obsidian, Logseq, plain markdown, doesn't matter). You will produce ~200 pages of notes.

**Calendar**
- Two 2-hour weeknight blocks + one 6-hour weekend block. Book them. Treat them like a client meeting.
- One Sunday review slot, 30 minutes: what did I actually finish, what carries to next week, one sentence learned.

**Baseline artifacts**
- Read the [Karpathy "Zero to Hero" course intro](https://karpathy.ai/zero-to-hero.html).
- Read chapter 1 of DDIA.
- Read chapters 1–3 of the [Rust Book](https://doc.rust-lang.org/book/).
- Order paper copies of DDIA, *Rust for Rustaceans*, and *Understanding Deep Learning* (Simon Prince, free PDF but paper is worth it).

---

## Phase 1 — Foundations Across All Three (Weeks 2–5)

Goal: get past the "everything is unfamiliar" barrier in each track. By end of phase you can talk about ownership, backprop, and replication without hedging.

### Week 2 — Rust ownership, first tools
- Rust Book ch 4–10 (ownership, references, structs, enums, generics, traits, lifetimes). Type it, don't just read it.
- Build **`ripcount`**: a Rust CLI that walks a directory and reports LOC per language faster than the Python version you'd write in 20 minutes. Learn `clap`, `rayon`, `walkdir`.
- **Deliverable:** repo with README + benchmark vs a Python equivalent.

### Week 3 — Micrograd + backprop by hand
- Karpathy's [micrograd video](https://www.youtube.com/watch?v=VMj-3S1tku0). Do NOT skim. Pause and code alongside.
- Re-derive backprop on paper for a 2-layer MLP. This is the single most important intuition you'll build.
- Read DDIA ch 2 (data models) + ch 3 (storage engines).
- **Deliverable:** `micrograd-from-scratch/` repo + a one-page write-up "how backprop actually works."

### Week 4 — makemore + a real Rust project
- Karpathy makemore parts 1–3 (bigrams → MLP → batchnorm).
- Rust: start **`kvstore-lite`** — a persistent key-value store using a log-structured file format (append-only + hashmap index). Bitcask-style. Just single-threaded and synchronous for now.
- Read DDIA ch 4 (encoding) + ch 5 (replication).
- **Deliverable:** makemore notebooks + first commit of `kvstore-lite`.

### Week 5 — makemore finished + first system-design write-up
- Karpathy makemore parts 4–5 (WaveNet, backprop through it manually).
- System design: write your first teardown — pick **Cloudflare Workers** because it's small enough to actually understand. Read [How Workers Works](https://blog.cloudflare.com/cloud-computing-without-containers/), the [V8 isolates post](https://blog.cloudflare.com/cloud-computing-without-containers/), and the [Durable Objects post](https://blog.cloudflare.com/introducing-workers-durable-objects/). Write a 1500-word teardown as if teaching a new grad.
- Rust: add crash-recovery to `kvstore-lite` (replay the log on startup).
- **Deliverable:** Cloudflare Workers teardown post (private draft is fine) + `kvstore-lite` v0.2.

---

## Phase 2 — Building Blocks (Weeks 6–12)

Goal: ship substantial things in each track. The unifying theme is *"I built this end to end."*

### Week 6 — GPT from scratch (DEEP: ML)
- Karpathy [nanoGPT video](https://www.youtube.com/watch?v=kCc8FmEb1nY). Code the whole thing, don't clone. This is a rite of passage.
- Train it on TinyShakespeare, then on a custom corpus of your own writing / bookmarks.
- Understand every line of the attention block; write it out from memory by end of week.
- **Deliverable:** `nano-gpt-ravi/` repo with your trained model + a page explaining self-attention.

### Week 7 — HTTP service in Rust
- Learn Tokio (async/await, tasks, channels). [Tokio's own tutorial](https://tokio.rs/tokio/tutorial) is the best resource.
- Build **`notes-api-rs`** — the same notes API you'd write in Node, but idiomatic Rust. `axum` router, `sqlx` for Postgres, `tracing` for structured logs, `thiserror` + `anyhow` for errors.
- Learn `#[tokio::test]` and integration tests with `testcontainers`.
- **Deliverable:** repo + a "learnings from writing my first real Rust service" post-it in your notes.

### Week 8 — Netflix teardown (SYNTH: system design)
- Read: [Netflix TechBlog](https://netflixtechblog.com/) archive on Zuul, Eureka, Chaos Monkey, Open Connect, the Adaptive Bitrate posts, and the recent GraphQL Federation posts.
- Read the [HighScalability Netflix post](http://highscalability.com/blog/2015/11/9/a-360-degree-view-of-the-entire-netflix-stack.html).
- Watch the QCon "Netflix Architecture" talks (search YouTube; Adrian Cockcroft's older ones + the more recent Reliability Engineering ones).
- Write a full teardown (~3000 words): the CDN (Open Connect), the microservices mesh, the chaos engineering discipline, the data pipeline, and one specific thing they do that would surprise a senior candidate.
- **Deliverable:** Netflix teardown blog draft.

### Week 9 — Sampling, tokenization, and the second Rust project
- Deep on tokenization: read Karpathy's [Let's build the GPT Tokenizer](https://www.youtube.com/watch?v=zduSFxRajkE). Implement a BPE tokenizer from scratch in Python.
- Sampling strategies: temperature, top-k, top-p (nucleus), beam search. Implement each.
- Rust: harden `notes-api-rs` — add auth (JWT), rate limiting middleware, and OpenTelemetry tracing.
- **Deliverable:** BPE tokenizer repo + updated Rust service with observability.

### Week 10 — DDIA halfway + AWS core (DEEP: system design)
- DDIA ch 6 (partitioning) + ch 7 (transactions). These are the two hardest chapters in the book and worth reading twice.
- AWS survey (skim the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)): pick one service per pillar and know it cold — VPC (networking), EC2 + ECS + EKS (compute), S3 + EBS + RDS + DynamoDB (storage/DB), SQS + SNS + Kinesis (messaging), CloudFront + Route 53 (edge), IAM (security).
- **Deliverable:** DDIA notes (yours, in your notes vault) + an AWS "cheatsheet" you'd hand to a new hire on your team.

### Week 11 — Cloudflare teardown + async Rust patterns
- Second full teardown, deeper than week 5's: **Cloudflare** as a stack. R2, D1, Queues, Durable Objects, Workers, KV, Analytics Engine, Zero Trust. Read the announcement blog for each; understand *why* Cloudflare exists as an alternative to AWS for edge-first workloads.
- Rust: async patterns — `tokio::select!`, `join!`, cancellation safety, structured concurrency. Read Alice Ryhl's blog posts, they're canonical.
- **Deliverable:** Cloudflare teardown post + a `tokio-patterns/` repo with 6–8 small examples.

### Week 12 — Phase 2 capstone (SYNTH)
- One combined build: deploy `nano-gpt-ravi` as an inference endpoint from `notes-api-rs`, with proper token streaming (SSE) and rate limiting. Deploy to a single AWS region behind an ALB.
- Write a phase-2 retro: what changed in how you think about programs.
- **Deliverable:** Combined repo + retro post.

---

## Phase 3 — Modern Architectures (Weeks 13–19)

Goal: leave the "toy models and toy systems" world. Understand what makes 2026-era transformers and 2026-era systems actually work.

### Week 13 — RoPE, GQA, RMSNorm, SwiGLU (DEEP: ML)
- Read the [RoPE paper](https://arxiv.org/abs/2104.09864), the [GQA paper](https://arxiv.org/abs/2305.13245), the [RMSNorm paper](https://arxiv.org/abs/1910.07467), and the [SwiGLU note](https://arxiv.org/abs/2002.05202).
- Modify your nanoGPT to use all four. Retrain on TinyShakespeare and compare loss curves.
- Read the [Llama 3 paper](https://arxiv.org/abs/2407.21783) — every architectural choice is defended, it's the best modern-transformer paper to study.
- **Deliverable:** `nano-gpt-modern/` fork with the four upgrades + a comparison notebook.

### Week 14 — Distributed systems from DDIA + KV store gets serious
- DDIA ch 8 (troubles with distributed systems) + ch 9 (consistency & consensus). Slowly.
- Rust: expand `kvstore-lite` to a server. Add a length-prefixed binary protocol. Add a simple leader-follower replication (single follower for now, async).
- **Deliverable:** DDIA distributed-systems notes + `kvstore-server/` v0.1 with replication.

### Week 15 — Uber teardown + attention efficiency
- Uber teardown: read Uber Engineering Blog on H3 (geospatial indexing), Ringpop, Cadence/Temporal, their DB stack (Schemaless, Cassandra, Docstore), Michelangelo (ML platform). Uber is the canonical "hyperscale operational transactional system" case study.
- ML: read the [FlashAttention paper](https://arxiv.org/abs/2205.14135) and [FlashAttention-2](https://arxiv.org/abs/2307.08691). You don't need to implement flash attention — you need to *understand* why it exists (memory hierarchy, IO-awareness).
- **Deliverable:** Uber teardown draft + a one-page "what problem does FlashAttention solve" note.

### Week 16 — AWS deep-dive week (DEEP: system design)
- Go deep on the things you *don't* touch in daily work:
  - DynamoDB: read the [DynamoDB paper](https://www.usenix.org/system/files/atc22-elhemali.pdf) (2022 USENIX ATC). Understand global tables, adaptive capacity, DAX.
  - Aurora: read the [Aurora paper](https://web.stanford.edu/class/cs245/readings/aurora.pdf) — the "log is the database" architecture is a landmark idea.
  - S3: read the [S3 team's Werner Vogels post](https://www.allthingsdistributed.com/2023/07/building-and-operating-a-pretty-big-storage-system.html) on how S3 actually works internally.
  - Kinesis vs MSK vs SQS vs EventBridge: know when to pick which.
- **Deliverable:** AWS "deep dive" note in your vault (~15 pages of your own words).

### Week 17 — Railway + edge platforms + Rust database experiments
- Railway teardown: it's a smaller company but the architecture is unusually well-documented. Read their [engineering blog](https://blog.railway.com/), especially the posts on their scheduler, their metric pipeline, and their multi-cloud story. Compare with Fly.io.
- Rust: prototype adding a simple SQL-ish query engine to `kvstore-server`. Use `sqlparser-rs` to parse; build a naive executor. This is the exercise that teaches you what databases actually do.
- **Deliverable:** Railway + Fly teardown post + `kvstore-server/` v0.2 with basic queries.

### Week 18 — Mixture of Experts + inference intro
- Read the [Switch Transformer paper](https://arxiv.org/abs/2101.03961) + the [Mixtral paper](https://arxiv.org/abs/2401.04088). Understand MoE routing, load balancing, expert parallelism.
- Skim the [DeepSeek-V3 paper](https://arxiv.org/abs/2412.19437) for a modern take on MoE + MLA (multi-head latent attention).
- Start reading the [vLLM paper](https://arxiv.org/abs/2309.06180) (Efficient Memory Management for LLM Serving with PagedAttention). This is your bridge into phase 4.
- **Deliverable:** MoE + MLA notes + first-pass vLLM paper notes.

### Week 19 — Phase 3 SYNTH: multi-region KV store
- Take `kvstore-server` and deploy it to two AWS regions. Add cross-region replication (async). Document conflict semantics honestly.
- Write it up: "How I built a distributed KV store in Rust, and what I learned about consistency."
- **Deliverable:** Public repo + blog post (this is post #2 in your public series).

---

## Phase 4 — Inference Engines (Weeks 20–25)

Goal: understand how modern LLM serving actually works, and prove it by writing something that runs a real model.

### Week 20 — vLLM internals (DEEP: ML)
- Re-read the vLLM paper carefully. Read the [vLLM source](https://github.com/vllm-project/vllm) — start with `vllm/engine/llm_engine.py` and `vllm/core/scheduler.py`.
- Understand: paged attention (why KV cache fragmentation is the killer problem), continuous batching (vs static batching), prefill vs decode phases, and speculative decoding.
- Deploy vLLM locally on your GPU box, serve a small model (Llama-3.2-1B), and hit it with concurrent requests. Watch the scheduler behavior.
- **Deliverable:** vLLM internals write-up (~3000 words).

### Week 21 — llama.cpp + quantization
- Read [llama.cpp](https://github.com/ggerganov/llama.cpp) — different design philosophy (single binary, CPU-first, GGUF format). Read the [ggml](https://github.com/ggerganov/ggml) primer.
- Quantization: understand INT8, INT4, GPTQ, AWQ, GGUF quantization types. Read the [GPTQ paper](https://arxiv.org/abs/2210.17323) and skim [AWQ](https://arxiv.org/abs/2306.00978).
- Run the same model at fp16, INT8, and INT4. Measure quality (perplexity on a held-out set) and throughput.
- **Deliverable:** Quantization comparison notebook + notes.

### Week 22 — Rust + inference (SYNTH)
- Explore [`candle`](https://github.com/huggingface/candle) — Hugging Face's Rust ML framework — and [`llama.cpp`'s Rust bindings](https://github.com/utilityai/llama-cpp-rs).
- Build **`inference-server-rs`**: an axum server that wraps candle or llama-cpp bindings and exposes an OpenAI-compatible `/v1/chat/completions` endpoint with SSE streaming.
- Add continuous batching (even a naive version — batch requests within a 20ms window).
- **Deliverable:** Working Rust inference server + a benchmark vs raw vLLM.

### Week 23 — Discord teardown
- Discord teardown: they're the canonical "started in Elixir/Erlang, added Rust for hot paths" story. Read:
  - [How Discord stores trillions of messages](https://discord.com/blog/how-discord-stores-trillions-of-messages) (ScyllaDB migration)
  - [How Discord's Ready payload got 40% smaller](https://discord.com/blog/how-discords-ready-payload-got-40-smaller)
  - [Why Discord is switching from Go to Rust](https://discord.com/blog/why-discord-is-switching-from-go-to-rust)
  - The [read states architecture posts](https://discord.com/blog/using-rust-to-scale-elixir-for-11-million-concurrent-users)
- **Deliverable:** Discord teardown post — write it as "what a senior engineer at a scaling startup would learn from Discord's decisions."

### Week 24 — WhatsApp teardown + Erlang concepts
- WhatsApp teardown: the classic "1B users, 50 engineers, Erlang" story. Read Rick Reed's talks (they're archived on YouTube — search "WhatsApp Erlang Rick Reed"). Read the FreeBSD tuning post. Understand the actor model deeply.
- Now compare: Discord uses Elixir (Erlang VM), WhatsApp used Erlang directly, Cloudflare uses Rust + V8 isolates. What are the three different bets these companies made about concurrency? Write it up.
- **Deliverable:** WhatsApp teardown post + a "concurrency models compared" essay.

### Week 25 — Phase 4 capstone
- Improve `inference-server-rs`: add proper paged-attention-style KV cache management, prefix caching (reuse KV cache across requests with shared prefixes), and OpenAI streaming spec compliance.
- Load test it: 50 concurrent sessions, measure p50/p95/p99 time-to-first-token and inter-token latency.
- Write it up as blog post #3.
- **Deliverable:** Production-shaped inference server + benchmarks + blog post.

---

## Phase 5 — Agents at Production Scale (Weeks 26–32)

Goal: everything you've learned converges on a real agent platform.

### Week 26 — LangGraph mastery
- Do LangChain's [official LangGraph academy](https://academy.langchain.com/courses/intro-to-langgraph) in one intense week. Take notes on state design, conditional edges, checkpointers, and human-in-the-loop patterns.
- Build a docs-agent (like week 9 of the 12-week plan, but this time with full state persistence, streaming, and interrupts).
- **Deliverable:** `docs-agent-v2/` with LangGraph + your `inference-server-rs` as the backend.

### Week 27 — RAG at depth
- Read the [Cohere Rerank paper](https://arxiv.org/abs/2005.11401) (original RAG paper). Then read modern surveys: [RAG Survey (2024)](https://arxiv.org/abs/2312.10997).
- Chunking strategies: fixed-size, sentence, semantic (Anthropic's contextual chunking), late chunking. Implement three; compare retrieval quality on your corpus.
- Hybrid search: BM25 + dense + cross-encoder rerank. Build the pipeline.
- **Deliverable:** RAG comparison notebook + one write-up.

### Week 28 — Evals like an engineer, not a data scientist
- Read [Hamel Husain's evals series](https://hamel.dev/blog/posts/evals/).
- Build a proper eval suite: golden dataset (~100 examples), LLM-as-judge with a rubric, human-labeled subset, and CI integration.
- Track eval scores over time in a spreadsheet or SQLite DB.
- **Deliverable:** `eval-harness/` + a CI job that gates PRs.

### Week 29 — Multi-agent + tool use (DEEP: ML/agents)
- Read Anthropic's [Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents) — canonical.
- Build a multi-agent LangGraph system: a planner, a researcher (with tools), a critic, and a synthesizer. Add loop-detection and budget enforcement.
- Read a couple of papers: [ReAct](https://arxiv.org/abs/2210.03629), [Reflexion](https://arxiv.org/abs/2303.11366), [Toolformer](https://arxiv.org/abs/2302.04761).
- **Deliverable:** Multi-agent system running on your infra + short paper-reading notes.

### Week 30 — Safety, prompt injection, PII (DEEP: agents)
- Read Simon Willison's entire [prompt injection tag](https://simonwillison.net/tags/promptinjection/) archive.
- Read [OWASP LLM Top 10](https://owasp.org/www-project-top-10-for-large-language-model-applications/).
- Implement: input filtering, output filtering, PII redaction (Presidio), tool allow-listing per user, and per-user rate limits.
- Red-team your own agent with 20 attack prompts. Document what got through.
- **Deliverable:** Safety middleware in your agent platform + a red-team write-up.

### Week 31 — Production deploy + multi-region (SYNTH: all three tracks)
- Deploy the full agent platform (LangGraph + `inference-server-rs` + Postgres + Redis) to EKS in `us-east-1`.
- Add a passive replica in `us-west-2` with cross-region Postgres replication.
- Wire OpenTelemetry traces from the Rust inference server *and* from the LangGraph agent into Honeycomb. Build one Grafana + one Honeycomb dashboard.
- Run a load test at 100 concurrent sessions and document what breaks first.
- **Deliverable:** Deployed platform + runbook + load-test report.

### Week 32 — Fine-tuning & RLHF (conceptual + one implementation)
- Read the [RLHF paper](https://arxiv.org/abs/2203.02155) (InstructGPT) + the [DPO paper](https://arxiv.org/abs/2305.18290). DPO is the practical modern choice.
- Do a small LoRA fine-tune of a 1B–3B model on a task specific to your domain. Use [Unsloth](https://github.com/unslothai/unsloth) or [Axolotl](https://github.com/axolotl-ai-cloud/axolotl) — actually implementing training is out of scope, but you should ship one fine-tune.
- Deploy the fine-tuned model in your inference server.
- **Deliverable:** Fine-tuned model + a comparison ("did this actually help?") post.

---

## Phase 6 — Zig, Portfolio, Polish (Weeks 33–36)

Goal: convert 8 months of work into a portfolio that lands interviews.

### Week 33 — Zig sprint
- Read [Ziglearn](https://ziglearn.org/) end to end (~4 hours).
- Watch [Andrew Kelley's Zig talks](https://kristoff.it/blog/zig-cost-of-abstractions/) (search YouTube for his ZigSHOWTIME talks).
- Build one thing in Zig: rebuild `ripcount` from week 2. Learn `comptime`, error unions, allocator patterns.
- Write a "Rust vs Zig, one project each" comparison post. You will have earned every opinion in this post.
- **Deliverable:** `ripcount-zig/` + blog post #4.

### Week 34 — Capstone polish
- The capstone from weeks 25/31 is already good; this week is about making it *presentable*.
- One README on the umbrella repo with: system architecture diagram, sequence diagram of an agent request, cost breakdown, eval results, load-test numbers, and a "things I'd do differently" section.
- Record a 20-minute Loom walkthrough. This is the single artifact recruiters share internally.
- Update your personal site with the portfolio front and center.
- **Deliverable:** Umbrella repo + video + updated ravikprasad.com.

### Week 35 — Blog series + talk
- Publish the 6 blog posts you've written across the phases (Cloudflare, Netflix, Uber, WhatsApp, Discord, Rust vs Zig, and the capstone story — pick your best six).
- Prepare a 30-minute technical talk. Suggested title: *"Building an inference engine and agent platform from scratch: what a senior product engineer learns in 9 months."* Rehearse it three times, record it once, upload to YouTube.
- Submit the talk to two meetups or conferences (any local Rust / AI / systems meetup).
- **Deliverable:** Published blog series + recorded talk.

### Week 36 — Resume rewrite + interviews
- Rewrite your resume around the new capabilities. Every bullet in the Envisso section should be reframed with the vocabulary you've earned.
- Add a "Selected Projects" section with your 3 strongest builds.
- Do two paid mock interviews (Hello Interview, interviewing.io) — one system design, one AI/ML.
- Draft cover letters for three specific target roles (Anthropic FDE, Vercel Product Engineer, Linear Senior Product Engineer AI).
- Start applying.

---

## The Reading List (curated, no filler)

**Books**
- *Designing Data-Intensive Applications* — Kleppmann. The book. Read it twice.
- *Rust for Rustaceans* — Jon Gjengset. Read after the Rust Book.
- *Understanding Deep Learning* — Simon Prince. [Free PDF](https://udlbook.github.io/udlbook/). The best modern DL textbook.
- *The Rust Programming Language* (aka "the Book") — free at [doc.rust-lang.org/book](https://doc.rust-lang.org/book/).
- *Zero to Production in Rust* — Luca Palmieri. Best resource for real-world Rust services.
- *System Design Interview Vol. 1 & 2* — Alex Xu. Useful for vocab and structure, not depth.

**Video / courses**
- Karpathy's [Zero to Hero](https://karpathy.ai/zero-to-hero.html). Non-negotiable.
- [LangGraph Academy](https://academy.langchain.com/courses/intro-to-langgraph).
- [Hello Interview](https://www.hellointerview.com/) YouTube channel for system design mocks.
- Jon Gjengset's [YouTube channel](https://www.youtube.com/@jonhoo) for advanced Rust. Painful and worth it.

**Papers (in reading order)**
- Attention Is All You Need
- GPT-2 & GPT-3 papers (Radford et al.)
- FlashAttention & FlashAttention-2
- RoPE, GQA, RMSNorm, SwiGLU (short papers, batch them)
- vLLM / PagedAttention
- Llama 3 (best modern architecture reference)
- Mixtral / DeepSeek-V3 (MoE)
- InstructGPT (RLHF) + DPO
- ReAct + Reflexion + Toolformer
- DynamoDB, Aurora, Spanner (the three great cloud-DB papers)

**Engineering blogs to internalize**
- Cloudflare — the best system-design writing on the internet, essentially free.
- Netflix TechBlog
- Discord Engineering
- Uber Engineering
- AWS Architecture Blog / All Things Distributed (Werner Vogels)
- Anthropic Engineering (small but exceptional)
- Simon Willison's [blog](https://simonwillison.net) for LLM tools + safety

---

## Cost Envelope

| Item | Monthly |
|---|---|
| AWS labs (see 12-week plan discipline) | $60–120 |
| GPU compute (Runpod/Lambda/Colab Pro) | $30–80 |
| LLM API credits (Claude, OpenAI for evals + agent runs) | $20–50 |
| Books (paper, one-time ~$150 over 9 months) | ~$17 |
| Mock interviews (weeks 8, 22, 36) | ~$150 total |
| **Estimated total** | **$130–270/month** |

If money gets tight: skip the GPU rental (Colab Pro is enough for everything until Phase 4, week 22), and read papers on arXiv instead of buying books. Everything on the reading list is legally free online except *DDIA*, *Rust for Rustaceans*, and *Zero to Production in Rust*.

---

## Cadence & Discipline Tips

- **One "definition of done" per week:** at the end of each week you should be able to point at a commit, a note, a diagram, or a blog draft. If a week ends with nothing pointable, adjust before the next week begins.
- **Compound interest matters more than intensity.** Missing one weeknight is fine; missing three weeks in a row is what kills the plan. Design for consistency, not heroics.
- **Publish quarterly.** End of Phase 2, 4, and 6 = publish something public (blog post, GitHub project write-up, or LinkedIn post). This makes the work legible and — critically — inbound-attracting.
- **Say no to shiny objects.** In 9 months at least three new models, three new frameworks, and one new language will make headlines. Note them, don't chase them. Depth compounds; breadth doesn't.

---

## What Success Looks Like at Month 9

A portfolio with:
- A **Rust inference server** with paged attention and streaming, benchmarked against vLLM.
- A **multi-agent LangGraph platform** deployed multi-region on EKS with evals, safety middleware, and observability.
- A **distributed KV store in Rust** with replication, a wire protocol, and basic queries.
- A **nanoGPT-modern** with RoPE/GQA/RMSNorm/SwiGLU, plus a small LoRA fine-tune.
- **Six blog posts** with a coherent narrative arc.
- **One recorded technical talk** (~30 min).
- **Six system-design teardowns** in your private notes vault (Netflix, Uber, Discord, WhatsApp, Cloudflare, AWS deep-dive) that you can reproduce on a whiteboard in 45 minutes each.
- A **rewritten resume** where every bullet earns its space.

That's what walking into a Staff-level interview at Anthropic, Vercel, Linear, or Ramp looks like when you've *actually* done the work — not when you've done a bootcamp. And it makes it plausible to interview at the AI labs themselves.
