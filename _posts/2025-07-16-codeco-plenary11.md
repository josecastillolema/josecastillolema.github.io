---
title:  "CODECO 11th Plenary Meeting & IETF 123 hackaton"
last_modified_at: 2025-07-16
tags:
  - en
  - networks
  - redhat
  - research
toc: true
toc_sticky: true
---

![](/assets/images/posts/2025-07-16-codeco-plenary11/1.jpg)

## CODECO 11th Plenary Meeting

The [CODECO project](https://he-codeco.eu/), held its 11th Plenary Meeting on July 16th – 18th, 2025, at Telefonica District premises in Madrid, Spain.

CODECO is shaping the future of edge-cloud infrastructure operations and management. It has already developed a novel working approach for intelligent management of workflows and resources in the edge-cloud continuum supporting different profiles of applications e.g., data-intense, real-time, green etc. It also gives tools for developers to leveraging advanced edge-cloud resource management capabilities on top of Kubernetes, Kubeflow, Edgenet and other frameworks.

One of the most enjoyable aspects of this project, is that meetings are practical, hands-on, to the point and results focused. As the project is in its last year, there are many things developed and many things happening every month.

![](/assets/images/posts/2025-07-16-codeco-plenary11/2.jpg)
![](/assets/images/posts/2025-07-16-codeco-plenary11/3.jpg)

## IETF 123 hackaton

![](/assets/images/posts/2025-07-16-codeco-plenary11/4.jpg)

The Internet Engineering Task Force (IETF) is holding a [hackathon](https://wiki.ietf.org/en/meeting/123/hackathon) to encourage developers and subject matter experts to discuss, collaborate, and develop utilities, ideas, sample code, and solutions that show practical implementations of IETF standards.

    🗓 When: 19 - 20 July 2025 (Saturday - Sunday)
    🇪🇸 Where: Meliá Castilla

This is your chance to shine, showcase your skills, and **compete for a €2800 reward** by securing a spot in the top 3 of each challenge. 🏆💰

### CODECO challenges

 - **Challenge 1: Green network observability and reporting**

   This challenge explores energy-awareness observability and reporting that may suit telco-cloud resource management. The challenge relies on approaches and code under development in the context of the Horizon Europe project CODECO, and also relates with a new informational draft being proposed to [IETF GREEN](https://datatracker.ietf.org/doc/bofreq-palmero-getting-ready-for-energy-efficient-networking-green/).

   The main goal of this challenge is to consider enhancements to CODECO (as a relevant example of an edge-cloud orchestrator that provides a data-compute-network approach) in terms of monitoring and exporting metrics aligned with GREEN principles e.g., CO2 network footprinting, green workload percentage.

   The reporting will be provided to Prometheus and eventually to SDN; alignment to YANG will be considered.

 - **Challenge 2: Joint exposure of compute and network metrics for path selection**

   This enhancement to the CODECO framework introduces [Computing-Aware Traffic Steering (CATS)](https://datatracker.ietf.org/wg/cats/about/)-aligned path selection capabilities by leveraging CODECO’s existing compute and network observability. The goal is to support computing-aware traffic steering across the Edge-Cloud continuum, in line with the architectural direction of IETF CATS.

   CODECO collects real-time infrastructure metrics -such as CPU , memory usage, latency, and network congestion— from its ACM and NetMA components and aggregates them via the PDLC-CA module into node and cluster scores. These scores are then used to inform microservice placement and potential workload redirection decisions, consistent with CATS principles.

   The aim is to adapt the current approach to provide scores from PDLC and PDLC-CA to NetMA which may assist in Path ranking and selection based on dynamic network latency and congestion data.

   This design supports the CATS use case of service instance selection and path steering based on combined compute and network metrics, helping optimize service experience in distributed, heterogeneous edge environments.

   Setup instructions [here](https://gitlab.eclipse.org/eclipse-research-labs/codeco-project/hackathon/challenge-2/codeco-cats/-/blob/main/Installing_the_CODECO_VM__Extracting_Metrics__and_Building_a_Three-Level_Metrics_Management_.pdf).

![](/assets/images/posts/2025-07-16-codeco-plenary11/5.jpg)
