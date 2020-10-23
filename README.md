# Traefik Loadbalancer deployment on HashiCorp Nomad

This is a Nomad job file which can be used to run dockerised Traefik on your
cluster as a system task. This ensures it will run on all nomad nodes which
have available resources.

## Project Website
<https://doc.traefik.io/traefik/>

## Prerequisites

* Deploy a Nomad Cluster or Developer instance <https://www.nomadproject.io/docs/install>
* Consul should also be installed as Traefik uses this for discovery
* Download [Levant]<https://github.com/hashicorp/levant>

## Deploy

To deploy Traefik to your nomad cluster using levant use this command:

```bash
levant deploy -log-level=debug -address=<YOUR_NOMAD_ADDRESS> -var-file=variables.yaml  traefik.nomad
```

the output should be something similar to:

```bash
Guys-MBP-533:Traefik_lb guy$ levant deploy -log-level=debug -address=https://nomad.eu-guystack.original.aws.hashidemos.io:4646 -var-file=variables.yaml  traefik.nomad
2020-10-23T14:59:55+01:00 |DEBU| template/render: variable file extension .yaml detected
2020-10-23T14:59:55+01:00 |DEBU| template/render: no command line variables passed
2020-10-23T14:59:55+01:00 |INFO| helper/variable: using variable with key config and value map[image:traefik:v2.2 network_mode:host] from file
2020-10-23T14:59:55+01:00 |INFO| helper/variable: using variable with key resources and value map[cpu:100 memory:128 network:map[mbits:10] port:map[api:8081 http:8080]] from file
2020-10-23T14:59:55+01:00 |INFO| helper/variable: using variable with key consul and value map[address:http://127.0.0.1:8500 scheme:http] from file
2020-10-23T14:59:55+01:00 |INFO| helper/variable: using variable with key service and value map[name:Traefik] from file
2020-10-23T14:59:55+01:00 |INFO| helper/variable: using variable with key job and value map[datacenters:[eu-west-2a eu-west-2b eu-west-2c dc1] region:global type:system] from file
2020-10-23T14:59:55+01:00 |DEBU| levant/plan: triggering Nomad plan
2020-10-23T14:59:55+01:00 |INFO| levant/plan: job is a new addition to the cluster
2020-10-23T14:59:55+01:00 |INFO| levant/deploy: job is not running, using template file group counts job_id=traefik
2020-10-23T14:59:55+01:00 |INFO| levant/deploy: triggering a deployment job_id=traefik
2020-10-23T14:59:57+01:00 |DEBU| levant/job_status_checker: running job status checker for job job_id=traefik
2020-10-23T14:59:57+01:00 |INFO| levant/job_status_checker: job has status running job_id=traefik
2020-10-23T14:59:57+01:00 |INFO| levant/job_status_checker: task traefik in allocation 48eedcbd-d57a-40bd-a7ad-484f394cd8b5 now in pending state job_id=traefik
2020-10-23T14:59:57+01:00 |INFO| levant/job_status_checker: task traefik in allocation 53411b3b-53cc-5fd9-27f1-8b3d700c494e now in pending state job_id=traefik
2020-10-23T14:59:57+01:00 |INFO| levant/job_status_checker: task traefik in allocation 6a20193d-e39d-8d51-9af8-8f16322fdaa1 now in pending state job_id=traefik
2020-10-23T14:59:57+01:00 |INFO| levant/job_status_checker: task traefik in allocation 919b4092-14b5-87d3-f769-4861699d7be4 now in pending state job_id=traefik
2020-10-23T14:59:57+01:00 |INFO| levant/job_status_checker: task traefik in allocation dc4bd41f-86ff-f900-a285-db3c58a4afb7 now in pending state job_id=traefik
2020-10-23T15:00:00+01:00 |INFO| levant/job_status_checker: task traefik in allocation 6a20193d-e39d-8d51-9af8-8f16322fdaa1 now in running state job_id=traefik
2020-10-23T15:00:01+01:00 |INFO| levant/job_status_checker: task traefik in allocation 919b4092-14b5-87d3-f769-4861699d7be4 now in running state job_id=traefik
2020-10-23T15:00:01+01:00 |INFO| levant/job_status_checker: task traefik in allocation dc4bd41f-86ff-f900-a285-db3c58a4afb7 now in running state job_id=traefik
2020-10-23T15:00:01+01:00 |INFO| levant/job_status_checker: task traefik in allocation 53411b3b-53cc-5fd9-27f1-8b3d700c494e now in running state job_id=traefik
2020-10-23T15:00:01+01:00 |INFO| levant/job_status_checker: task traefik in allocation 48eedcbd-d57a-40bd-a7ad-484f394cd8b5 now in running state job_id=traefik
2020-10-23T15:00:01+01:00 |INFO| levant/job_status_checker: all allocations in deployment of job are running job_id=traefik
2020-10-23T15:00:01+01:00 |INFO| levant/deploy: job deployment successful job_id=traefik
Guys-MBP-533:Traefik_lb guy$ 
```
## Variables
the variables.yaml file allow you to configure this deployment to best suit your necessity

| key      | Description | default value     |
| :---        |    :----:   |          ---: |
| job      | contains all the variables for the job stanza       | -   |
| job.datacenters   | list of all the datacenters this deployment can deploy to        |    - 'eu-west-2a'    - 'eu-west-2b'    - 'eu-west-2c'    -'dc1' |
| job.region   | region name        | global      |
| job.type   | type of Nomad job         | system     |
| config   | contains all the variables for the task config stanza        | -   |
| config.image   | Traefik Docker Image         | "traefik:v2.2"      |
| config.network_mode   | Docker networking mode        | "host"      |
| resources   | contains all the variables for the task resources stanza        | -      |
| resources.cpu   | value for cpu resource allocation        | 100      |
| resources.memory   | value for cpu resource allocation        | 128      |
| resources.network   | contains all the variables for the networking config in the resources stanza        | -      |
| resources.network.mbits   | contains all the variables for the port config in the resources networking stanza        | 10      |
| resources.network.port   | Docker networking mode        | "host"      |
| resources.network.port.http   | port number for the "http" port        | "8080"      |
resources.network.port.api   | port number for the "api" port        | "8081"      |
| consul   | contains all the variables for the consul config in the Traefik config template        | -      |
| consul.address   | iP or FQDN and port of the consul agent (or cluster)        | "http://127.0.0.1:8500"      |
| consul.scheme   | tells traeffik what networking scheme it should use for Consul communication         | "http"      |
| service   | contains all the variables for consul service config stanza       | -      |
| service.name   | name that will identify instances of this task in consul registry        | "Traefik"      |
| service.tags   | tags added to the consul service        | - 'traefik' - 'global'      |
