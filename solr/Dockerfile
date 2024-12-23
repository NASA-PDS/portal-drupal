# Solr Dockerfile
# ===============
#
# Solr customized for Drupal by Web Strategy Team, then refined further for the
# Planetary Data System portal.

FROM solr:7
WORKDIR /solr-core
COPY Docker-Drupal-Demo/solr-conf/* .
COPY solr/initialize.sh /opt/docker-solr/scripts
RUN ["/opt/docker-solr/scripts/initialize.sh"]
LABEL "org.label-schema.name"="PDS Drupal Solr"
LABEL "org.label-schema.description"="Solr search engine customized for use by the PDS Portal running Drupal"
LABEL "org.label-schema.version"="0.0.0"
