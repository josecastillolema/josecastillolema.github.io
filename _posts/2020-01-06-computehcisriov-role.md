---
title:  "ComputeHCISriov role for Director/TripleO"
last_modified_at: 2020-01-06T16:00:58-04:00
tags:
  - en
  - nfv
  - openstack
  - redhat
toc: false
---


Hyper-converged SR-IOV role for compute nodes.

Change `700887` proposed and merged upstream: [https://review.opendev.org/#/c/700887/](https://review.opendev.org/#/c/700887/)

```
###############################################################################
# Role: ComputeHCISriov #
###############################################################################
- name: ComputeHCISriov
 description: |
 Compute Node with SR-IOV role hosting Ceph OSD too
 networks:
 - InternalApi
 - Tenant
 - Storage
 - StorageMgmt
 - Management
 default_route_networks: ['Management']
 disable_upgrade_deployment: True
 RoleParametersDefault:
 TunedProfileName: "cpu-partitioning"
 # CephOSD present so serial has to be 1
 update_serial: 1
 ServicesDefault:
 - OS::TripleO::Services::Aide
 - OS::TripleO::Services::AuditD
 - OS::TripleO::Services::BootParams
 - OS::TripleO::Services::CACerts
 - OS::TripleO::Services::CephClient
 - OS::TripleO::Services::CephExternal
 - OS::TripleO::Services::CephOSD
 - OS::TripleO::Services::CertmongerUser
 - OS::TripleO::Services::Collectd
 - OS::TripleO::Services::ComputeCeilometerAgent
 - OS::TripleO::Services::ComputeNeutronCorePlugin
 - OS::TripleO::Services::ComputeNeutronL3Agent
 - OS::TripleO::Services::ComputeNeutronMetadataAgent
 - OS::TripleO::Services::ComputeNeutronOvsAgent
 - OS::TripleO::Services::Docker
 - OS::TripleO::Services::Fluentd
 - OS::TripleO::Services::IpaClient
 - OS::TripleO::Services::Ipsec
 - OS::TripleO::Services::Iscsid
 - OS::TripleO::Services::Kernel
 - OS::TripleO::Services::LoginDefs
 - OS::TripleO::Services::MetricsQdr
 - OS::TripleO::Services::MySQLClient
 - OS::TripleO::Services::NeutronBgpVpnBagpipe
 - OS::TripleO::Services::NeutronSriovAgent
 - OS::TripleO::Services::NeutronSriovHostConfig
 - OS::TripleO::Services::NeutronVppAgent
 - OS::TripleO::Services::NovaCompute
 - OS::TripleO::Services::NovaLibvirt
 - OS::TripleO::Services::NovaLibvirtGuests
 - OS::TripleO::Services::NovaMigrationTarget
 - OS::TripleO::Services::Ntp
 - OS::TripleO::Services::ContainersLogrotateCrond
 - OS::TripleO::Services::OpenDaylightOvs
 - OS::TripleO::Services::Rhsm
 - OS::TripleO::Services::RsyslogSidecar
 - OS::TripleO::Services::Securetty
 - OS::TripleO::Services::SensuClient
 - OS::TripleO::Services::SkydiveAgent
 - OS::TripleO::Services::Snmp
 - OS::TripleO::Services::Sshd
 - OS::TripleO::Services::Timezone
 - OS::TripleO::Services::TripleoFirewall
 - OS::TripleO::Services::TripleoPackages
 - OS::TripleO::Services::Vpp
 - OS::TripleO::Services::OVNController
 - OS::TripleO::Services::OVNMetadataAgent
 - OS::TripleO::Services::Ptp
```