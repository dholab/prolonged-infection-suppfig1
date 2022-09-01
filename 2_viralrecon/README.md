## Step 2: Run quality control, variant-calling, and protein effect annotation on the reads

In this step, we use Docker to run viralrecon version 2.5, which is available with documentation on [nf-core](https://nf-co.re/viralrecon/2.5). This pipeline combines state-of-the-art quality control, read mapping, variant calling, and more for detecting within-host, low-frequency variants in the viral population sampled with sequencing reads.

### A brief troubleshooting note

We recommend you run this workflow on a machine with at least 4 cores available. We also recommend allocating at least 16 GB of RAM to Docker, which you can do in the "Resources" section of the Docker engine settings.

Finally, if the workflow starts but does not appear to be running, we recommend canceling it, restarting Docker, and re-running the workflow.
