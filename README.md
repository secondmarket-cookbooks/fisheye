Description
===========

Installs [Atlassian Fisheye](https://www.atlassian.com/software/fisheye), a popular revision-control system repository viewer. Fisheye can visualize CVS, Subversion, Git and Mercurial repositories, among others.

Requirements
============

## Platforms

* CentOS 6/RHEL6

This cookbook might work on CentOS 5, but has not been tested.

## Cookbooks

* database
* postgresql

Attributes
==========

This cookbook assumes that you'll install Fisheye into /opt, but this is configurable.

Roadmap
=======

* Support other databases other than PostgreSQL.
* Support databases on machines other than "localhost".
* Fisheye is installed by default with an HSQLDB and the migration is not currently automated; see https://confluence.atlassian.com/display/FISHEYE/Migrating+to+PostgreSQL for directions.

License and Author
==================

- Author:: Julian Dunn <jdunn@secondmarket.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

