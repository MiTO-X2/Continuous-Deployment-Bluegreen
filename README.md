# Ship It: Continuous Delivery vs. Continuous Deployment

An executable DevOps tutorial demonstrating **Continuous Integration (CI), Continuous Delivery (CD), and Continuous Deployment (CDep)** through a practical blue-green deployment pipeline.

The tutorial runs entirely in the browser using **KillerCoda**. No local Docker installation, cloud account, or additional credentials are required for learners.

## Overview

The tutorial places the learner in the role of both a developer and a release engineer. Starting from a small Python web service called **Demo Shop**, the learner progressively builds, tests, deploys, verifies, and releases a versioned application using a blue-green setup.

The tutorial demonstrates:

- Automated testing and container builds
- Versioned Docker artifacts
- Blue-green deployments
- Deployment verification with health and smoke tests
- Continuous Delivery with a manual release gate
- Continuous Deployment with automatic release
- Failed-release detection and automatic abort
- Dark launches using feature flags
- Instant rollback
- The distinction between **deployment** and **release**
- When Continuous Deployment is appropriate — and when it is not
- CI that runs automatically on every commit

## Learning objectives

After completing the tutorial, the learner should be able to:

1. Distinguish **Continuous Integration, Continuous Delivery, and Continuous Deployment**.
2. Explain the difference between **deployment** and **release**.
3. Implement a basic automated pipeline consisting of **test → build → version → deploy**.
4. Perform a blue-green deployment with automated verification.
5. Explain how a manual approval gate implements Continuous Delivery.
6. Explain how removing that gate enables Continuous Deployment.
7. Demonstrate how automated health checks can prevent a broken release from reaching users.
8. Use feature flags and dark launches to separate deployment from feature exposure.
9. Perform and explain an instant rollback.
10. Explain why CI should trigger automatically on every commit rather than relying on a manual run.
11. Critically evaluate when Continuous Deployment is useful and when a manual release process is more appropriate.

## Tutorial structure

The tutorial currently contains 9 guided steps:

| Step | Topic                                                               | Main concept                        |
| ---- | ------------------------------------------------------------------- | ----------------------------------- |
| 1    | The service and its environments                                    | Manual deployment and observability |
| 2    | Continuous Integration: every change is built and tested            | Automated tests and builds          |
| 3    | Production and deployment strategies: why blue-green                | Blue-green deployment               |
| 4    | Continuous Delivery: the manual gate                                | Manual approval gate                |
| 5    | Continuous Deployment: remove the gate                              | Automatic release                   |
| 6    | The safety net: a bad release never reaches users                   | Failed-release abort                |
| 7    | Dark launches and instant rollback                                  | Feature flags and rollback          |
| 8    | Continuous Integration for real: every commit triggers the pipeline | Automatic CI on every commit        |
| 9    | Reflection: when, when not, for whom                                | Critical evaluation                 |

The tutorial uses a small web service with two important endpoints:

- `/health` — used to determine whether the service is healthy.
- `/version` — used to identify which version is running.

## Architecture

The tutorial runs inside a disposable Ubuntu VM. nginx acts as the only user-facing traffic router while two application environments, **blue** and **green**, provide the two deployment slots.

The pipeline follows the general flow:

```text
GIT COMMIT → TEST → BUILD → VERSION → DEPLOY → VERIFY → RELEASE
                                              │
                                      ┌───────┴───────┐
                                      │               │
                                   manual          automatic
                                   approval          release
                                      │               │
                                      └───────┬───────┘
                                              ▼
                                            nginx
                                          /       \
                                      blue :8081  green :8082
```

Only nginx normally receives user traffic. A new version is deployed to the idle application slot and verified before traffic is switched to it.

The key distinction is:

- **Deployment:** put the new version into an environment and verify that it works.
- **Release:** decide whether users should receive traffic from that version.

Continuous Delivery keeps the release decision available to a human. Continuous Deployment automates that final decision.

## Running the tutorial

The tutorial is designed to be executed through **KillerCoda**.

### For learners

1. Open the published KillerCoda scenario.
2. Click **START**.
3. Wait for the environment setup to complete.
4. Follow the steps from 1 to 9.
5. Execute the provided commands in the terminal.
6. Click **CHECK** after completing each step.
7. Continue through the tutorial until the final reflection.

No local Docker or Python installation is required.

### For development

The scenario source is maintained in this GitHub repository and connected to KillerCoda.

Changes to the scenario can be tested by pushing the updated files to the configured repository branch and starting a fresh KillerCoda scenario.

## Technologies

- **KillerCoda** — executable tutorial platform
- **Ubuntu 24.04** — tutorial execution environment
- **Docker** — application containerization
- **Python 3** — Demo Shop web service and tests
- **nginx** — reverse proxy and traffic router
- **Bash** — CI/CD and deployment automation
- **Git** — source control and simulated developer changes

## Key design decisions

### Blue-green deployment

Two application slots are maintained so that a new release can be deployed and verified without replacing the currently live version.

### Automated verification

The pipeline verifies the candidate version directly before releasing it. The `/health` and `/version` endpoints provide simple signals that can be checked automatically.

### Continuous Delivery vs. Continuous Deployment

The tutorial deliberately uses the same deployment mechanism in two modes:

- **Continuous Delivery:** the pipeline deploys and verifies the candidate, then waits for human approval.
- **Continuous Deployment:** the pipeline automatically releases the verified candidate.

This makes the difference between the two practices visible rather than purely theoretical.

### Failure handling

A deliberately broken release is introduced later in the tutorial. Its unit tests can pass, but its runtime health check fails. The pipeline therefore aborts the release while the previous version remains live.

### Dark launch and rollback

A later release contains a feature that is deployed but not exposed to users. The tutorial then demonstrates how the previous release can be restored through the other blue-green slot.

### CI as an automatic gate

In the final CI step, a Git hook runs the pipeline after every commit. This reinforces the principle that integration should happen automatically and continuously, while release remains a separate decision.

## Grounding material

The tutorial is based on the following material:

- _An Introduction to Continuous Integration, Delivery and Deployment_ — DigitalOcean
- _The Top 10 Adages in Continuous Deployment_ — Parnin et al.
- _Continuous delivery_ — Wikipedia
- _Continuous deployment_ — Wikipedia
- _Blue-green deployment_ — Wikipedia
- _Deployment environment_ — Wikipedia

The tutorial uses these sources to connect the practical exercises to concepts such as automation, deployment frequency, feedback loops, release safety, and deployment strategies.

## Project purpose

This project was created as an executable DevOps tutorial for a university course assignment on **Continuous Delivery and Continuous Deployment**.

The emphasis is on learning by doing: instead of only describing a CI/CD pipeline, the learner builds, tests, deploys, verifies, releases, breaks, and rolls back a working example inside a disposable environment.

It is intentionally small, but it reflects the core idea behind modern deployment practices: automate the repetitive work, keep each change small, verify before release, and recover quickly when a decision is wrong.
