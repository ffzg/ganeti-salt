Ganeti salt
===========

Salt states for Ganeti node setup.

**Goals:**

1. Easy Cluster customization through pillar (examples included) 
2. DRBD optimizations
3. Flexible network configuration
4. Stable (versioned releases)
5. Keep it simple!

**Todo:**

* bounding network node target
* remove loads of hardcoded variables
* write proper Debian network configuration
* other various checks and enhancements
* ~~migrate to ganeti 2.9/2.10~~

Ganeti salt is tested on Debian Wheezy, ganeti 2.9.2 using KVM hypervisor, if you manage modify states and get them running on any other distribution or hypervisor please send pull request and add yourself to authors below.

Design notes:
-------------

Example installation:
---------------------

Authors:
--------

* lblasc@znode.net (Luka Blaskovic)

License:
--------

* Code is licensed under Apache License 2.0
