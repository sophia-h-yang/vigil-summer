# VIGIL — Product Brief

## What VIGIL Is

VIGIL is a secure remote operations layer for deployed robots.

Robotics companies need a way to access, debug, and command machines in the field without exposing raw SSH, relying on shared VPNs, or trusting that the device is in a safe state. VIGIL solves this with three components:

- **vigil-agent** — runs on the robot. Calls home outbound to the control plane. Monitors the robot's state (including camera), detects anomalies, and executes commands on behalf of authorized operators.
- **vigil-server** — the control plane. Authenticates devices and operators, brokers sessions, stores the audit log, enforces policy. Operators never get raw access to the device — everything goes through the broker.
- **vigil CLI** — the operator interface. `vigil status robot-042`, `vigil exec robot-042 "systemctl restart navigation"`, `vigil logs robot-042`, `vigil verify robot-042`.

## The Core Insight

SSH-ing into the Pi doesn't solve the real problem of a device deployed far away on a customer network. The agent calls home — outbound only — so the robot never needs an open inbound port. It works through firewalls and NAT. The operator gets a brokered, audited session, not a raw terminal.

## Summer 2026 Raspberry Pi Demo

The MVP demonstrates an end-to-end remote operations scenario:

1. **vigil-agent** runs on the Pi with a camera attached.
2. The camera captures the scene. When the agent detects an anomaly (confidence > 0.80), it sends an `AnomalyAlert` to the control plane.
3. The operator's laptop receives the alert: `ALERT: robot-001 — person on floor (confidence: 0.92)`.
4. The operator runs `vigil status robot-001` — device state shows `ANOMALY_DETECTED`.
5. The operator runs `vigil exec robot-001 "systemctl status navigation"` to investigate remotely.
6. Every event — anomaly detected, alert sent, operator command, command result — is written to a tamper-evident audit log. Each entry is hash-chained to the previous one; no entry can be altered or deleted without detection.
7. The operator runs `vigil verify robot-001` — chain intact, every entry accounted for.

The 2-minute demo shows: something happens in front of the camera → alert appears on the operator's laptop → operator runs a remote command → `vigil logs` shows the full chain of events → `vigil verify` proves it's tamper-evident.

## Why This Architecture

The outbound connection model is the key design decision. A robot deployed at a customer site sits behind their firewall and NAT — you cannot SSH in directly. The agent calls home to a known address, establishing a persistent authenticated channel. The operator never needs credentials on the customer network. The broker logs everything, so there is always an answer to "who accessed this robot, when, and what did they do."

This is not just about the demo. It is about the primitive: a brokered, audited, authenticated channel to a deployed device. That primitive is what robotics companies need at scale.

## What VIGIL Proves (MVP)

- Which device sent the anomaly alert and when
- Which operator connected, which commands they ran, and what the results were
- That the audit log has not been tampered with after the fact
- That no unauthorized device can register with the control plane

## What VIGIL Does Not Yet Prove (Honest Limitations)

- The channel is not encrypted (no TLS yet)
- Device auth uses a shared secret, not a hardware-backed certificate
- No per-operator permission levels (any authenticated operator can exec)
- The agent binary itself is not attested — a compromised device could lie

## Path to Production

1. TLS on the agent-server channel
2. Mutual authentication with per-device certificates
3. Hardware-backed private key (TPM or TEE)
4. Per-operator permission levels (read-only vs. exec)
5. Remote attestation of device software state

## Broader Context

The MVP is a proof of concept for a primitive that does not yet exist in the robotics stack: a brokered, authenticated, tamper-evident channel from a deployed robot to an authorized human operator. Existing tele-ops platforms solve remote presence. None of them solve verified accountability for who accessed what, when, and what they did. VIGIL builds and demonstrates that primitive in Rust, on real hardware, by end of summer.
