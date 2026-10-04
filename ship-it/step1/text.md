# Step 1 — The service and its environments

**What:** meet Demo Shop, the service we will ship, and run it once by hand.

**Why:** you cannot automate what you have not run manually first. Note the two endpoints that make everything later possible: **`/health`** and **`/version`**.

> **Deployment environments.** Real organizations run tiers of environments — development, test, _staging_ (production-like), and _production_ ([Deployment environment, Wikipedia](https://en.wikipedia.org/wiki/Deployment_environment)).
> Our blue-green setup collapses staging and production into one production cluster with two identical slots: the _idle_ slot acts as a production-like staging environment for every release.

Look at the app and its version file:

`cat ~/tutorial/app/VERSION`{{exec}}

Run it the old-fashioned way (foreground, manual — the thing we are about to kill):

````bash
cd ~/tutorial
nohup python3 app/app.py 5000 >/tmp/app.log 2>&1 &
```{{exec}}

Probe its two **telemetry endpoints**:

`curl -s localhost:5000/health`{{exec}}

`curl -s localhost:5000/version`{{exec}}

> **Adage 1 — Every Feature Is an Experiment.** These endpoints are not
> decoration. The adages paper shows companies instrument *everything* with a
> "telemetry-first mindset" so deployments can be verified with data. Our whole
> pipeline will make decisions based on these two tiny JSON responses.

Stop the manual process — you will never start it by hand again:

`pkill -f "app.py 5000"`{{exec}}
````
