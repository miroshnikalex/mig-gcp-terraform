Notes:

Version 2.0.0:
- backend on gcs requires bucked to be created manually prior to terraform init run
- you can't use functions and variables when defining backend

Version 2.1.0:
 - generic MIG
 - generic images
 - generic healthchecks
 - not a fully reusable template for MIG  

Version 3.0.0-a:
 - don't use. Still in development

Version 4.0.0
 - MIG
 - Global HTTP LB
 - Healthchecks
 - Firewall rules

Version 4.1.0:
 - Added autoscaler to MIG
 - replaced a couple hardcoded values with variables

Version 4.2.0:
 - Added autohealing capabilities
 - Tested under the load
