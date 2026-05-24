# VIGIL — Product Spec (Living Document)

**Status: v0.1 — in progress**
*This document is updated as the product design evolves. Last updated: 2026-05-23.*

---

## What VIGIL Is

VIGIL is a secure remote operations layer for deployed robots. It lets authorized teams access, debug, and command machines in the field without exposing raw SSH, relying on shared VPNs, or trusting that the device is in a safe state.

**Elevator pitch:** Robotics teams need a way to reach deployed robots — to investigate anomalies, restart services, and audit what happened — without giving anyone raw shell access or depending on the customer's network. VIGIL is the broker that makes that possible.

## The Two Actors

**Operator** — a robotics support engineer or field technician. Uses the `vigil` CLI from their laptop. Sees device status, receives anomaly alerts, runs diagnostic commands, reviews the audit log.

**Robot** — a deployed device running `vigil-agent`. Calls home to the control plane. Detects anomalies via camera. Executes commands on behalf of authorized operators. Logs everything.

## What Problem It Solves

A robot deployed at a customer site sits behind their firewall. You cannot SSH in directly. You cannot ask the customer to open ports. You cannot use a shared VPN across every customer network. You need the robot to reach out to you — through a secure, authenticated channel — and you need a record of every interaction.

## The Agent Calls Home

The key design decision: vigil-agent opens an outbound connection to the control plane. The robot initiates. This means:
- No open inbound ports on the robot
- Works through any NAT or firewall
- The operator never needs credentials on the customer network

## Core User Flow (MVP)

1. Robot starts up → vigil-agent connects outbound to vigil-server
2. Device authenticates (device ID + shared secret for MVP)
3. Control plane registers device; operator can now see it via `vigil status`
4. Camera captures scene → agent runs anomaly detection every 30 seconds
5. Anomaly detected → agent sends AnomalyAlert to control plane
6. Control plane shows alert to operator: `ALERT: robot-001 — [description]`
7. Operator investigates: `vigil exec robot-001 "systemctl status navigation"`
8. Every event is written to the tamper-evident audit log
9. Operator can verify the log at any time: `vigil verify robot-001`

## The CLI Interface

```
vigil status [device_id]          — show connected devices and their state
vigil exec <device_id> <command>  — run a command on a device, stream output
vigil logs <device_id>            — show recent audit log entries for a device
vigil verify <device_id>          — verify audit log hash chain integrity
```

## Device States

| State | Meaning |
|---|---|
| Offline | Not connected to the control plane |
| Connecting | TCP connection in progress |
| Registering | Authentication in progress |
| Connected | Authenticated and sending heartbeats |
| Anomaly Detected | Agent has sent an AnomalyAlert |
| Disconnected | Was connected, connection dropped |

## What VIGIL Proves (MVP)

- Which device sent an anomaly alert and when
- Which operator ran which commands on which device and when
- That the audit log has not been altered after the fact
- That unauthorized devices cannot register

## What VIGIL Does Not Yet Prove

- The channel is not encrypted (no TLS)
- Device auth uses a shared secret, not a hardware cert
- No per-operator permission levels
- The agent binary itself is not attested

## MVP Scope

**In:**
- vigil-agent on Raspberry Pi with USB camera
- vigil-server control plane running on laptop
- vigil CLI: status, exec, logs, verify
- Anomaly detection via mock analyzer (confidence threshold 0.80)
- AnomalyAlert from agent to control plane
- Hash-chained audit log for all events
- Device registry with hardcoded allowed list
- Heartbeat loop with last-seen tracking

**Out (explicit):**
- TLS / encrypted channel
- Certificate-based device auth
- Per-operator permission levels
- Real vision API (GPT-4o, Gemini) — mock analyzer only
- Multi-device management beyond one Pi
- Web dashboard
- Mobile alerts

## Open Questions

- What commands should the agent refuse to run, regardless of operator?
- What is the right heartbeat interval for battery-powered robots vs. wired?
- How should the operator be notified of an anomaly if they are not watching the terminal?

---

*Update this document whenever a product decision changes. The code implements what this spec decides.*
