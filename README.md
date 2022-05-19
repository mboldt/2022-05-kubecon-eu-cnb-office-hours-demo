# Cloud Native Buildpacks Office Hours Demo - Kubecon EU 2022

Here we build a simple Ruby app using [Paketo Buildpacks](https://paketo.io/).
We store the buildpack-generated Software Bill of Materials (SBOM) files when we build.
We scan the SBOM files using [Grype](https://github.com/anchore/grype) and see that one of our dependencies has a CVE.
We then update the dependency, rebuild, and scan the new SBOM to see that it has no known vulnerabilities.

The app is a very simple Ruby/Rack web app.

```
less app.rb config.ru Gemfile
```

To build the container image, while exposing the SBOM, we run the command:

```
pack build sample-ruby-app --builder paketobuildpacks/builder:base --sbom-output-dir sbom
```

Let's see the app up and running:

```
docker run --name sample-ruby-app --detach --env PORT=8080 --rm --publish 8080:8080 sample-ruby-app
open http://localhost:8080
```

We look at the SBOM files:

```
tree sbom
```

We see SBOM for files in the cache and in the image that gets launched.
These SBOM files also exist in the image itself.
These buildpacks write the SBOM in several formats (CycloneDX, SPDX, and Syft).
We scan the Syft SBOM from the gems we use with the Grype tool:

```
grype -q sbom:sbom/launch/paketo-buildpacks_bundle-install/launch-gems/sbom.syft.json
```

We see that there is a known vulnerability (these are the same underlying issue, just from two different sources).
I didn't have a chance to try to exploit it for the demo, but [CVE-2020-8184 is a secure cookie vulnerability](https://nvd.nist.gov/vuln/detail/CVE-2020-8184).
It allows for forgery of secure or host-only cookies if the name is URL encoded.
We see that it is fixed in the latest version of Rack, version 2.2.3.
So, we upgrade that dependency and rebuild.

```
sed -i '' 's/2\.2\.2/2.2.3/' Gemfile
bundle lock --update
pack build sample-ruby-app --builder paketobuildpacks/builder:base --sbom-output-dir new-sbom
```

We rescan the new SBOM with Grype and see no known vulnerabilities:

```
grype -q sbom:new-sbom/launch/paketo-buildpacks_bundle-install/launch-gems/sbom.syft.json
```

This is a small example of the power and interoperability that the SBOM features of Cloud Native Buildpacks offers.
