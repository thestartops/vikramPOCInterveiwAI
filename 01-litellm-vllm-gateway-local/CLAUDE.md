# POCInterveiws — local project rules

This folder is dedicated to **interview-prep POCs only** — hands-on Kubernetes/DevOps/platform
practice so the user can confidently explain and defend what was built in a real interview.
It is unrelated to the Skyler production infra rules in `~/CLAUDE.md` (no SSH servers, no
production services here — this is a local Kind cluster, throwaway by design).

More than one POC will live here over time (the LiteLLM/vLLM/Azure-failover gateway is the
first). Apply everything below to all of them, not just the current one.

## Working style for every POC here

1. **Step by step, nothing built ahead of what's been verified.** Build one small piece, stop,
   explain it, let the user run the verification commands themselves, wait for them to confirm
   before moving on. Do not batch multiple unverified steps together.

2. **Every file must be explained, not just created.** Before or immediately after writing a
   file, say plainly: what it is, why it exists, what would break or be missing without it. If a
   file's purpose can't be stated in a sentence the user would find convincing in an interview,
   don't add it. No filler files, no speculative scaffolding beyond what's needed for the concept
   at hand.

3. **Prefer hands-on / visual verification over trusting command output alone.** Whenever a
   concept has a UI, dashboard, or browser-visible surface (e.g. a NodePort URL, a health
   endpoint, a rendered template diff, Argo CD's UI in a future POC), explicitly tell the user to
   open it and look, not just run a CLI command — the point is practical muscle memory for
   demoing this live, not just a working config.

4. **Ask for explicit go/no-go before each step**, and cross-check the user's own command output
   (not just assume success) before continuing.

5. **No invented/fabricated secrets, endpoints, or credentials.** Real secret material is always
   the user's to supply (via a gitignored values/secrets file); anything mocked (e.g. a
   stand-in for a cloud service the user doesn't have access to) must be clearly labeled as a
   mock and why it's there.

6. **At the end of a POC, the user will ask for a rating.** When asked, assess the user's actual
   understanding (e.g. by asking them to explain a few key pieces back, or reviewing what
   questions came up during the build) and give an honest 1-10 with specific gaps to shore up —
   not a courtesy high score.

## Current POC: LiteLLM LLM gateway

- Local Kind cluster (`infra/kind/kind-config.yaml`), Helm chart at `charts/llm-gateway/`
  (chosen over Kustomize deliberately — more commonly asked about in interviews).
- vLLM deployed in-cluster as the primary backend; Azure OpenAI as failover — but since there's
  no real Azure OpenAI resource available, the failover target is a **local mock server**
  standing in for Azure's API shape, clearly labeled as a mock everywhere it appears.
- `_trash/` holds superseded scaffolding (an earlier flat-manifest attempt, then a Kustomize
  attempt) kept only because `rm` is blocked in this session — safe for the user to delete
  whenever.
