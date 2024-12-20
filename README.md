# 🥀 Portal Drupal

This is the PDS Engineering Node's repository for deploying a [Drupal-based](https://new.drupal.org/home) using the [Web Strategy Team](https://github.com/Web-Strategy-Team/)'s [Docker Drupal Demo](https://github.com/Web-Strategy-Team/Docker-Drupal-Demo) as a starting point.

The purpose is to automatically deploy the home page (or "portal") of the [NASA](https://www.nasa.gov/) [Planetary Data System](https://pds.nasa.gov/) to its cloud environment with a minimal of muss and fuss. The goal is to leverage [GitHub Actions](https://github.com/features/actions) to generate container images, publish them to registries, and create roles and resources in [NASA Mission Cloud Platform (MCP)](https://www.nasa.gov/wp-content/uploads/2023/07/533091-apr-jun-2023-it-talk-design-0.pdf), as well as instantly update the infrastruture as needed as the software changes and needs evolve.


## 🏛️ Structure

This repository takes advantage of the previously mentioned "Docker Drupal Demo". In addition, it leverages the following published packages:

- [wds, or Web Design System](https://www.npmjs.com/package/@nasapds/wds), a React-based but pure CSS implementation for the PDS Design System (see also the [source repository](https://github.com/NASA-PDS/wds) and ignore the Python references)
- [wds-react](https://www.npmjs.com/package/@nasapds/wds-react), a React-based component library for the PDS based on the Horizon Design System (see also the [source repository](https://github.com/NASA-PDS/wds-react))


## ♊️ Cloning

This repository references submodules, so in addition to cloning it, you'll need to initialize and update the submodules as follows:

    git clone https://github.com/NASA-PDS/portal-drupal.git  # or via ssh: git@github.com:NASA-PDS/…
    git submodule init
    git submodule update

Or do it all at once with:

    git clone --recurse-submodules https://github.com/NASA-PDS/portal-drupal.git


## 🎬 GitHub Actions

TBD.

- Container image building: Solr, Drupal (and MySQL?)
- Terraform applying

### 🤫 Secrets

TBD.


## 🧑‍🔧 Manual Deployment

TBD. Secrets. Env vars. Etc.


## 👥 Contributing

Within the NASA Planetary Data System, we value the health of our community as much as the code. Towards that end, we ask that you read and practice what's described in these documents:

-   Our [contributor's guide](https://github.com/NASA-PDS/.github/blob/main/CONTRIBUTING.md) delineates the kinds of contributions we accept.
-   Our [code of conduct](https://github.com/NASA-PDS/.github/blob/main/CODE_OF_CONDUCT.md) outlines the standards of behavior we practice and expect by everyone who participates with our software.


### 🔢 Versioning

We use the [SemVer](https://semver.org/) philosophy for versioning this software.


## 📃 License

The project is licensed under the [Apache version 2](LICENSE.md) license.


## Miscellaneous Notes

- @nutjob4life thinks this should be called `portal-cms` but was voted down despite his years of experience with content management systems and changing technologies 😏
- The 🥀 emoji is synonymous with "droop", which sounds like part of the word "Drupal" 🤭
