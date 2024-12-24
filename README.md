# 🥀 Portal Drupal¹²

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


| Key                     | Purpose
|:------------------------|:---------------------------------------------------------------|
| `AWS_ACCOUNT_ID`        | To generate the URI to the ECR for container image publication |
| `AWS_ACCESS_KEY_ID`     | Identification for cloud services                              |
| `AWS_SECRET_ACCESS_KEY` | Credential for cloud services                                  |
| `WEB_STRATEGY_TEAM_PAT` | So GitHub Actions can clone private submodule⁴                 |


## 🧑‍🔧 Manual Deployment

TBD. Secrets. Env vars. Etc.


### Elastic Container Registry

GitHub Actions is already configured to register images built to support this project with the AWS Elastic Container³ Registry (ECR). However, if you ever need to build things manually, you'll need to log in with your ECR's login password:

    aws configure
    aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin ACCOUNT.dkr.ecr.us-west-2.amazonaws.com

Replace `ACCOUNT` with your AWS account ID.


### Multiplatform Images

The PDS Portal runs in the cloud on AWS systems with the `amd64` architecture. However, GitHub Actions is set up to make all images support both `amd64` and `arm64`. If you wish to build these images locally, you'll need to set up Docker Buildx. This is not necessary thanks to GitHub Actions automation, but may have some utility for local testing.

To set up Docker Buildx, run:

    docker buildx create --name NAME --use
    docker buildx inspect --bootstrap | grep '^Platforms'

Replace `NAME` with whatever name you like. The second command shows you what platforms you can build locally. Nominally we use `linux/amd64` and `linux/arm64`.


### 🌞 Solr Image

You can manually build the Solr image used by this repository, though this is not recommended. [GitHub Actions are set up to automate the construction and publication of this image](.github/workflows/solr.yaml).

To build the image for your current host platform and load it into your local Docker registry:

    docker image build --file solr/Dockerfile --tag solr-portal:latest .

For multiple platforms, you can build and publish to the ECR in one step:

    aws ecr create-repository --repository-name solr-portal  # note the repositoryUri
    docker buildx build --platform linux/amd64,linux/arm64 \
        --tag REPOSITORY-URI:latest \
        --file solr/Dockerfile --push \
        .

Replace `REPOSITORY-URI` with the URI from `aws ecr create-repository`.

Note: it doesn't make much sense to load a multiplatform image into your local Docker registry as your local Docker installation supports only your current host platform, but you can do so if you wish by replacing `--push` with `--load`.


## 👥 Contributing

Within the NASA Planetary Data System, we value the health of our community as much as the code. Towards that end, we ask that you read and practice what's described in these documents:

-   Our [contributor's guide](https://github.com/NASA-PDS/.github/blob/main/CONTRIBUTING.md) delineates the kinds of contributions we accept.
-   Our [code of conduct](https://github.com/NASA-PDS/.github/blob/main/CODE_OF_CONDUCT.md) outlines the standards of behavior we practice and expect by everyone who participates with our software.


### 🔢 Versioning

We use the [SemVer](https://semver.org/) philosophy for versioning this software.


## 📃 License

The project is licensed under the [Apache version 2](LICENSE.md) license.


## Notes

¹@nutjob4life thinks this should be called `portal-cms` but was voted down despite his years of experience with content management systems and changing technologies 😏

²The 🥀 emoji is synonymous with "droop", which sounds like part of the word "Drupal" 🤭

³It's actually an _image_ registry; it doesn't register running containers.

⁴This is currently set one of @nutjob4life's personal access tokens because we know his account has access to the Web Strategy Team's repositories. We should switch to a "service" account like `pdsen-ci` and ask if the Web Strategy Team will give it access.
