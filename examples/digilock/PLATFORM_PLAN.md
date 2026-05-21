# Digilock Platform Plan

## Goals

1. Run locker workflows fully offline on each kiosk.
2. Separate hardware integration from business UI apps.
3. Allow central management and app deployment at scale.
4. Provide a simple SDK/API so third parties can build kiosk apps safely.

## Proposed Runtime Topology

1. `digilock-hw-agent` (privileged local daemon)
2. `kiosk app runtime` (frontend app in Chromium)
3. `local static app host` (nginx)
4. `control-plane connector` (inside hw-agent or separate service)

## Phase 1 (Now)

1. Establish offline base image and system services.
2. Define local API contract (`contracts/hw-bridge-openapi.yaml`).
3. Build one reference app (gym mode).

## Phase 2

1. Add signed app bundles with atomic version switching.
2. Introduce app manifest and capability model (locks, card reader, telemetry).
3. Add integration test rig with fake lock/card devices.

## Phase 3

1. Add central control plane (fleet + policy + app publishing).
2. Roll out staged updates and health-based rollback.
3. Add audit/event relay with offline queue + sync.

## Additional Repositories To Create

1. `digilock-hw-agent`
2. `digilock-kiosk-apps`
3. `digilock-sdk`
4. `digilock-control-plane`

## Suggested Next Milestone

Build the `digilock-hw-agent` first and keep API compatibility strict.
All apps should consume only that API, never direct hardware drivers.