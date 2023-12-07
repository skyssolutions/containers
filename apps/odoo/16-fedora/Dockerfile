FROM fedora:36

SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

# Generate locale C.UTF-8 for postgres and general locale data
ENV LANG C.UTF-8
# Install some deps
RUN dnf -y install wkhtmltopdf

# Install Odoo
ENV ODOO_VERSION 16.0
# renovate: datasource=docker depName=odoo
ARG ODOO_RELEASE=20231207
RUN curl -o odoo.rpm -sSL http://nightly.odoo.com/${ODOO_VERSION}/nightly/rpm/odoo_${ODOO_VERSION}.${ODOO_RELEASE}.rpm \
    && dnf localinstall odoo.rpm -y

# Copy entrypoint script and Odoo configuration file
COPY ./apps/odoo/16-fedora/entrypoint.sh /
COPY ./apps/odoo/16-fedora/odoo.conf /etc/odoo/
#COPY entrypoint.sh /
#COPY odoo.conf /etc/odoo/

# Set permissions and Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
RUN chown odoo /etc/odoo/odoo.conf \
    && mkdir -p /mnt/extra-addons \
    && chown -R odoo /mnt/extra-addons
VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

# Expose Odoo services
EXPOSE 8069 8071 8072

# Set the default config file
ENV ODOO_RC /etc/odoo/odoo.conf

COPY ./apps/odoo/16-fedora/wait-for-psql.py /usr/local/bin/wait-for-psql.py
#COPY wait-for-psql.py /usr/local/bin/wait-for-psql.py

# Set default user when running the container
USER 568

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]
