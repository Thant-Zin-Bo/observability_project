flowchart LR

    %% =========================================================
    %% Styles
    %% =========================================================
    classDef developer fill:#E3F2FD,stroke:#1565C0,color:#0D47A1,stroke-width:1.5px;
    classDef git fill:#FCE4EC,stroke:#C2185B,color:#880E4F,stroke-width:1.5px;
    classDef iac fill:#FFF3E0,stroke:#EF6C00,color:#E65100,stroke-width:1.5px;
    classDef gcp fill:#E8F5E9,stroke:#2E7D32,color:#1B5E20,stroke-width:1.5px;
    classDef runtime fill:#F3E5F5,stroke:#7B1FA2,color:#4A148C,stroke-width:1.5px;
    classDef telemetry fill:#E0F7FA,stroke:#00838F,color:#006064,stroke-width:1.5px;
    classDef grafana fill:#FFF8E1,stroke:#F9A825,color:#6D4C00,stroke-width:1.5px;
    classDef security fill:#FFEBEE,stroke:#C62828,color:#B71C1C,stroke-width:1.5px;

    %% =========================================================
    %% Developer and GitHub
    %% =========================================================
    DEV[Developer<br/>Thant Zin Bo]:::developer

    subgraph GITHUB["GitHub Repository"]
        direction TB
        REPO[Source code<br/>Infrastructure and documentation]:::git
        BRANCH[Feature branch<br/>and pull request]:::git
        CI[GitHub Actions<br/>Terraform validate<br/>Ansible lint<br/>Python tests<br/>Secret scanning]:::git

        REPO --> BRANCH
        BRANCH --> CI
    end

    DEV -->|Creates changes| BRANCH
    CI -->|Validated changes merged| REPO

    %% =========================================================
    %% Infrastructure and Configuration Automation
    %% =========================================================
    subgraph AUTOMATION["Infrastructure and Configuration Automation"]
        direction TB

        TF[Terraform<br/>Remote state, budget controls,<br/>VPC, subnet, firewall, IAM, VM]:::iac

        INVENTORY[Ansible inventory<br/>Terraform outputs or<br/>GCP dynamic inventory]:::iac

        ANSIBLE[Ansible<br/>Linux baseline, Docker,<br/>order-api and Alloy configuration]:::iac

        TF -->|Outputs VM connection details| INVENTORY
        INVENTORY -->|Targets provisioned VM| ANSIBLE
    end

    REPO -->|Terraform code| TF
    REPO -->|Ansible playbooks and roles| ANSIBLE

    %% =========================================================
    %% GCP Environment
    %% =========================================================
    subgraph GCP["Google Cloud Platform - Development Environment"]
        direction TB

        BUDGET[GCP Billing Budget<br/>and cost alert]:::security

        subgraph NETWORK["VPC Network"]
            direction LR
            VPC[VPC]:::gcp
            SUBNET[Custom subnet<br/>Controlled VM connectivity]:::gcp
            FIREWALL[Restrictive firewall rules<br/>IAP or allowlisted SSH;<br/>API port only for controlled demo access]:::security

            VPC --> SUBNET --> FIREWALL
        end

        STATE[(Cloud Storage<br/>Terraform remote state)]:::gcp

        SA[Dedicated VM service account<br/>Least-privilege IAM]:::security

        subgraph VM["Compute Engine VM"]
            direction TB

            OS[Linux operating system]:::runtime
            DOCKER[Docker and Docker Compose]:::runtime

            subgraph APPSTACK["Application and Telemetry Stack"]
                direction LR

                API[FastAPI order-api<br/>/health, /metrics, orders,<br/>controlled fault endpoints]:::runtime

                ALLOY[Grafana Alloy<br/>Prometheus scraper, log collector,<br/>and OTLP trace receiver]:::telemetry
            end

            OS --> DOCKER
            DOCKER --> API
            DOCKER --> ALLOY
        end

        BUDGET -.->|Cost monitoring| VM
        SUBNET --> VM
        FIREWALL --> VM
        SA -->|Runtime identity and permissions| VM
        STATE -.->|Remote state backend| TF
    end

    TF -->|Provisions| VPC
    TF -->|Provisions| STATE
    TF -->|Provisions| BUDGET
    TF -->|Provisions| SA
    TF -->|Provisions| VM

    ANSIBLE -->|Configures| OS

    %% =========================================================
    %% Grafana Cloud
    %% =========================================================
    subgraph GRAFANA["Grafana Cloud"]
        direction TB

        METRICS[Metrics<br/>Prometheus format]:::grafana
        LOGS[Logs<br/>Structured JSON]:::grafana
        TRACES[Traces<br/>OpenTelemetry]:::grafana

        DASH[Dashboards<br/>Golden Signals, host health,<br/>and Alloy health]:::grafana

        SLO[SLO and error-budget views<br/>Availability and latency]:::grafana

        ALERTS[Alert rules<br/>Service down, high errors,<br/>high p95 latency, SLO burn rate,<br/>and Alloy export failure]:::grafana

        EXPLORE[Explore<br/>Metric to log to trace<br/>incident investigation]:::grafana

        RUNBOOKS[Runbook URL annotations<br/>GitHub incident response procedures]:::grafana

        METRICS --> DASH
        METRICS --> SLO
        LOGS --> EXPLORE
        TRACES --> EXPLORE
        DASH --> ALERTS
        SLO --> ALERTS
        ALERTS --> RUNBOOKS
    end

    %% =========================================================
    %% Telemetry Pipeline
    %% =========================================================
    API -->|Prometheus scrape: /metrics| ALLOY
    API -->|OTLP traces| ALLOY
    DOCKER -->|Container JSON logs| ALLOY

    ALLOY -->|Alloy health and exporter metrics| METRICS
    ALLOY ==>|Exports metrics| METRICS
    ALLOY ==>|Exports logs| LOGS
    ALLOY ==>|Exports traces| TRACES

    %% =========================================================
    %% Operational Incident Flow
    %% =========================================================
    DEV -.->|Monitors service health| DASH
    DEV -.->|Reviews SLO status| SLO
    DEV -.->|Correlates metrics, logs, and traces| EXPLORE
    DEV -.->|Responds using procedures| RUNBOOKS
