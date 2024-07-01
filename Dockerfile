FROM ubuntu:24.04

# Update the package list and install apache2.
RUN apt-get update && \
    apt-get install -y apache2 lsb-release

# Show the build information when starting a shell in the container
ARG UNAME=${UNAME:-UNDEFINED}
ARG BUILD_DATE=${BUILD_DATE:-UNDEFINED}

# Modify .bashrc to display uname and build date on root login
RUN printf "echo OSNAME=$(grep \"^VERSION=\" /etc/os-release | cut -d'\"' -f2)" && \
    printf "echo 'Image built on: %s'\n" "$UNAME" >> /root/.bashrc && \
    printf "echo 'Image runs on: \n%s'\n" "$(lsb_release -a)" >> /root/.bashrc && \
    printf "echo 'Image created: %s'\n" "$BUILD_DATE" >> /root/.bashrc

# Generate a static index.html file containg the os name and date of the machine that build the image.
RUN printf "<html><body>\n" > /var/www/html/index.html && \
    printf "<h1>System Information</h1>\n" >> /var/www/html/index.html && \
    printf "<p>Image built on OS: %s</p>\n" "$UNAME" >> /var/www/html/index.html && \
    printf "<p>Image runs on OS: \n%s</p>\n" "$(lsb_release -a)" >> /var/www/html/index.html && \
    printf "<p>Image created: %s</p>\n" "$BUILD_DATE" >> /var/www/html/index.html && \
    printf "</body></html>\n" >> /var/www/html/index.html

# Add to motd in case one starts a login shell via ssh
RUN printf "Image built on: %s\n" "$UNAME" >> /etc/update-motd.d/10-build-info && \
    printf "Image runs on: \n%s\n" "$(lsb_release -a)" >> /etc/update-motd.d/10-build-info && \
    printf "Image created %s:\n" "$BUILD_DATE" >> /etc/update-motd.d/10-build-info

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apachectl", "-D", "FOREGROUND"]
