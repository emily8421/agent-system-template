"""Minimal single-agent demo for agent-system-template Batch 3a."""

from __future__ import annotations

import argparse
import hashlib
import json
from dataclasses import dataclass, field
from typing import Any


SENSITIVE_TERMS = ("token", "password", "secret", "api key", "private key")
INJECTION_PATTERNS = (
    "ignore rules",
    "ignore previous",
    "bypass confirmation",
    "disable safety",
    "show secret",
    "leak token",
    "system prompt",
)


def contains_any(text: str, patterns: tuple[str, ...]) -> bool:
    lower_text = text.lower()
    return any(pattern in lower_text for pattern in patterns)


def redact_sensitive(value: Any) -> Any:
    if isinstance(value, str):
        redacted = value
        for term in SENSITIVE_TERMS:
            redacted = redacted.replace(term, "[redacted]")
            redacted = redacted.replace(term.title(), "[redacted]")
            redacted = redacted.replace(term.upper(), "[redacted]")
        return redacted
    if isinstance(value, dict):
        return {key: redact_sensitive(item) for key, item in value.items()}
    if isinstance(value, list):
        return [redact_sensitive(item) for item in value]
    return value


def detect_prompt_injection(text: str) -> bool:
    return contains_any(text, INJECTION_PATTERNS)


@dataclass
class TraceRecorder:
    trace_id: str
    steps: list[dict[str, Any]] = field(default_factory=list)

    @classmethod
    def for_input(cls, user_input: str) -> "TraceRecorder":
        digest = hashlib.sha256(user_input.encode("utf-8")).hexdigest()[:12]
        return cls(trace_id=f"trace-{digest}")

    def record(self, actor: str, event: str, detail: dict[str, Any]) -> None:
        self.steps.append(
            {
                "step_id": f"T{len(self.steps) + 1:03d}",
                "actor": actor,
                "event": event,
                "detail": redact_sensitive(detail),
            }
        )


class DemoMemory:
    def __init__(self) -> None:
        self._items: list[dict[str, str]] = []

    def remember(self, key: str, value: str, trace: TraceRecorder) -> bool:
        if contains_any(f"{key} {value}", SENSITIVE_TERMS):
            trace.record("memory", "reject_sensitive", {"key": key, "reason": "sensitive_data"})
            return False

        safe_item = {"key": key, "value": value}
        self._items.append(safe_item)
        trace.record("memory", "store_safe_fact", safe_item)
        return True

    def snapshot(self) -> list[dict[str, str]]:
        return list(self._items)


class ToolRouter:
    TOOL_RISK = {
        "lookup_policy": "low",
        "draft_answer": "low",
        "publish_update": "high",
    }

    def run(
        self,
        name: str,
        payload: dict[str, str],
        trace: TraceRecorder,
        approve_high_risk: bool = False,
    ) -> dict[str, str]:
        risk = self.TOOL_RISK[name]
        if risk == "high" and not approve_high_risk:
            trace.record("tool_router", "approval_required", {"tool": name, "risk": risk})
            return {"status": "needs_approval", "message": "Human approval required."}

        trace.record("tool_router", "invoke_tool", {"tool": name, "risk": risk, "payload": payload})
        if name == "lookup_policy":
            return {
                "status": "ok",
                "message": "Use low-risk local tools directly and stop before external side effects.",
            }
        if name == "draft_answer":
            query = redact_sensitive(payload["query"])
            return {
                "status": "ok",
                "message": (
                    f"Policy answer: For '{query}', keep the plan short, record trace steps, "
                    "and require approval before publish actions."
                ),
            }
        if name == "publish_update":
            return {"status": "ok", "message": "Approved demo publish action recorded."}

        raise ValueError(f"Unknown tool: {name}")


def evaluate_answer(answer: str, trace: TraceRecorder) -> dict[str, bool]:
    result = {
        "has_answer": bool(answer.strip()),
        "has_trace": bool(trace.steps),
        "no_sensitive_terms": not contains_any(answer, SENSITIVE_TERMS),
    }
    trace.record("evaluator", "evaluate_answer", result)
    return result


def run_agent(user_input: str, approve_high_risk: bool = False) -> dict[str, Any]:
    prompt = user_input.strip()
    trace = TraceRecorder.for_input(prompt)
    trace.record("user", "request_received", {"prompt": prompt})
    trace.record("planner", "classify_request", {"profile": "single-agent"})

    if not prompt:
        trace.record("safety", "refuse_empty_prompt", {})
        return {
            "status": "refused",
            "reason": "empty_prompt",
            "output": "Request refused: empty prompt.",
            "trace_id": trace.trace_id,
            "trace": trace.steps,
            "memory": [],
        }

    if detect_prompt_injection(prompt):
        trace.record("safety", "refuse_prompt_injection", {"prompt": prompt})
        return {
            "status": "refused",
            "reason": "prompt_injection",
            "output": "Request refused: prompt injection detected.",
            "trace_id": trace.trace_id,
            "trace": trace.steps,
            "memory": [],
        }

    memory = DemoMemory()
    tools = ToolRouter()
    lower_prompt = prompt.lower()

    if "publish" in lower_prompt or "send" in lower_prompt:
        publish_result = tools.run(
            "publish_update",
            {"draft": prompt},
            trace,
            approve_high_risk=approve_high_risk,
        )
        if publish_result["status"] == "needs_approval":
            trace.record("agent", "stop_for_approval", {"reason": "high_risk_action"})
            return {
                "status": "needs_approval",
                "reason": "high_risk_action",
                "output": publish_result["message"],
                "trace_id": trace.trace_id,
                "trace": trace.steps,
                "memory": memory.snapshot(),
            }
        answer = publish_result["message"]
    else:
        policy = tools.run("lookup_policy", {"topic": prompt}, trace)
        memory.remember("last_topic", prompt, trace)
        draft = tools.run("draft_answer", {"query": prompt, "policy": policy["message"]}, trace)
        answer = draft["message"]

    eval_result = evaluate_answer(answer, trace)
    return {
        "status": "completed",
        "output": answer,
        "trace_id": trace.trace_id,
        "trace": trace.steps,
        "memory": memory.snapshot(),
        "eval": eval_result,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description="Run the single-agent demo.")
    parser.add_argument("prompt", help="User prompt for the demo agent.")
    parser.add_argument(
        "--approve-high-risk",
        action="store_true",
        help="Allow the demo high-risk publish tool to run.",
    )
    args = parser.parse_args()
    print(json.dumps(run_agent(args.prompt, args.approve_high_risk), ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
