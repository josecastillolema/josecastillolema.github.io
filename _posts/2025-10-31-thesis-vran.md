---
title:  "PhD Thesis defense: Sustainable Operation of Virtualized RAN Infrastructure"
description: PhD Defense of Nikolaos Apostolakis of IMDEA Networks Institute and University Carlos III of Madrid
last_modified_at: 2024-12-20
tags:
  - ai
  - en
  - networks
  - nfv
  - research
  - sdn
toc: true
toc_sticky: true
image: /assets/images/posts/2025-10-31-thesis-vran.jpg
image_link: https://networks.imdea.org/whatsnew/events-agenda/phd-thesis-defense-sustainable-operation-of-virtualized-ran-infrastructure/
---

This PhD thesis addresses the core challenges facing the sustainability and performance of vRANs as they transition from specialized hardware to flexible, cost-effective COTS servers. While this shift reduces costs, meeting the tight timelines the 5G technology dictates is extremely difficult on shared CPU-only infrastructure, often forcing operators to rely on power-hungry or inflexible hardware accelerators. The first major contribution introduces ATHENA, a ML-based MAC scheduler designed to solve this problem. Deployed as an O-RAN real-time application, ATHENA dynamically monitors real-time CPU congestion, including the ‘noisy neighbor’ effect from co-located non-RAN applications, and allocates radio resources accordingly. By improving the determinism and reliability of time-critical task execution on standard COTS servers, ATHENA effectively eliminates the need for expensive external accelerators. This work was made possible alongside the development of an open-source, fully cloud-native, end-to-end 5G testbed, a crucial system that democratizes access to vRAN research.

Moving beyond conventional processor-based solutions, the second core contribution of my research explores quantum computing as an alternative path towards a lower energy footprint for mobile networks. The thesis proposes Qu4Fec, a novel approach to the critical baseband processing task of Forward Error Correction. This solution reformulates the LDPC decoding problem as an optimization that can be natively solved on quantum hardware. Though initial experiments revealed the challenges posed by noise in current quantum systems, simulations show Qu4Fec outperforming existing state-of-the-art classical methods, highlighting its long-term potential. Ultimately, the thesis provides a crucial, forward-looking perspective, proposing architectural changes needed to allow future quantum machines to efficiently handle these critical mobile network workloads.

University
: Universidad Carlos III de Madrid (UC3M), Spain

Doctoral Program
: Telematic Engineering

Location
: Salón de Grados (Auditorio), Padre Soler, Campus Leganés, Madrid, Spain

Time
: 10:30

## About Nikolaos Apostolakis

Nikos Apostolakis is a PhD candidate in the NETCOM group at IMDEA Networks Institute and the Telematic Engineering department at Universidad Carlos III de Madrid. His interests include the performance evaluation and testing of 5G systems, and machine learning. Throughout his PhD, he carried out a four-month internship at NVIDIA in California, USA, and his work has been published in notable venues such as ACM SIGMETRICS, IEEE JSAC, and IEEE Communications Magazines.

## Thesis Advisors

 - Albert Banchs (Telematic Engineering Department, UC3M, Spain, and IMDEA Networks Institute, Spain)
 - Marco Gramaglia (Telematic Engineering Department, UC3M, Spain)


## Committee members

 - President: Nicolas Kourtellis, Operational R&D Manager, Keysight
 - Secretary: José Castillo Lema, Software Engineer, Red Hat
 - Panel member: Nina Slamnik-Krijestorac, Principal Investigator, University of Antwerp


