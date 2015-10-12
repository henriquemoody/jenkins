FROM jenkins:1.609.3

USER root

RUN apt-get update &&\
  apt-get install --yes --no-install-recommends\
    autoconf\
    bison\
    bzip2\
    file\
    g++\
    gcc\
    libc-dev\
    libcurl4-openssl-dev\
    libreadline6-dev\
    librecode-dev\
    libsqlite3-dev\
    libssl-dev\
    libxml2-dev\
    libxslt-dev\
    make\
    pkg-config\
    re2c\
    xz-utils\
    zlib1g-dev\
    $EXTRA_PACKAGES &&\
    rm -r /var/lib/apt/lists/*

ENV CONFIGURE_OPTIONS "--disable-cgi\
 --disable-debug\
 --enable-bcmath\
 --enable-mbstring\
 --enable-xmlreader\
 --enable-zip\
 --with-openssl\
 --with-xsl\
 --with-zlib\
 --with-zlib-dir=/usr\
 $EXTRA_CONFIGURE_OPTIONS"

# Build PHP 7.0
RUN curl -L https://downloads.php.net/~ab/php-7.0.0RC4.tar.bz2 | tar -x -j -C /usr/src &&\
  cd /usr/src/php-7.0.0RC4 &&\
  ./configure --prefix=/opt/php/7.0 --exec-prefix=/opt/php/7.0 --with-config-file-path=/opt/php/7.0/etc $CONFIGURE_OPTIONS &&\
  make -j"$(nproc)" &&\
  make install &&\
  cp /usr/src/php-7.0.0RC4/php.ini-development /opt/php/7.0/etc/php.ini &&\
  /opt/php/7.0/bin/php -v &&\
  rm -rf /usr/src/php-7.0.0RC4

# Build PHP 5.6
RUN curl -L https://secure.php.net/distributions/php-5.6.14.tar.bz2 | tar -x -j -C /usr/src &&\
  cd /usr/src/php-5.6.14 &&\
  ./configure --prefix=/opt/php/5.6 --exec-prefix=/opt/php/5.6 --with-config-file-path=/opt/php/5.6/etc $CONFIGURE_OPTIONS &&\
  make -j"$(nproc)" &&\
  make install &&\
  cp /usr/src/php-5.6.14/php.ini-development /opt/php/5.6/etc/php.ini &&\
  /opt/php/5.6/bin/php -v &&\
  rm -rf /usr/src/php-5.6.14

# Build PHP 5.5
RUN curl -L https://secure.php.net/distributions/php-5.5.30.tar.bz2 | tar -x -j -C /usr/src &&\
  cd /usr/src/php-5.5.30 &&\
  ./configure --prefix=/opt/php/5.5 --exec-prefix=/opt/php/5.5 --with-config-file-path=/opt/php/5.5/etc $CONFIGURE_OPTIONS &&\
  make -j"$(nproc)" &&\
  make install &&\
  cp /usr/src/php-5.5.30/php.ini-development /opt/php/5.5/etc/php.ini &&\
  /opt/php/5.5/bin/php -v &&\
  rm -rf /usr/src/php-5.5.30

# Build PHP 5.4
RUN curl -L https://secure.php.net/distributions/php-5.4.45.tar.bz2 | tar -x -j -C /usr/src &&\
  cd /usr/src/php-5.4.45 &&\
  ./configure --prefix=/opt/php/5.4 --exec-prefix=/opt/php/5.4 --with-config-file-path=/opt/php/5.4/etc $CONFIGURE_OPTIONS &&\
  make -j"$(nproc)" &&\
  make install &&\
  cp /usr/src/php-5.4.45/php.ini-development /opt/php/5.4/etc/php.ini &&\
  /opt/php/5.4/bin/php -v &&\
  rm -rf /usr/src/php-5.4.45

# Add php-path script to the $PATH
COPY php-path /usr/local/bin/

# Install Composer
RUN curl -sS https://getcomposer.org/installer | /opt/php/5.4/bin/php -- --install-dir=/usr/local/bin --filename=composer

USER jenkins
