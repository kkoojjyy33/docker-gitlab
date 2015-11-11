FROM sameersbn/ubuntu:14.04.20151023
MAINTAINER sameer@damagehead.com

RUN apt-get update && apt-get -y install software-properties-common python-software-properties
RUN add-apt-repository -y ppa:git-core/ppa && \
		add-apt-repository -y ppa:brightbox/ruby-ng && \
		apt-get update && \
		DEBIAN_FRONTEND=noninteractive \ 
		apt-get install -y build-essential checkinstall postgresql-client pwgen openssh-server \
			nginx git-core mysql-server redis-server python2.7 python-docutils \
			libmysqlclient-dev libpq-dev zlib1g-dev libyaml-dev libssl-dev \
			libgdbm-dev libreadline-dev libncurses5-dev libffi-dev \
			libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev \
			ruby2.1 ruby2.1-dev \
			supervisor logrotate locales curl && \
		gem install --no-ri --no-rdoc bundler && \
		apt-get clean # 20140519

ADD assets/setup/ /app/setup/
RUN chmod 755 /app/setup/install
RUN /app/setup/install

ADD assets/config/ /app/setup/config/
ADD assets/init /app/init
RUN chmod 755 /app/init

ADD authorized_keys /root/.ssh/

EXPOSE 22
EXPOSE 80
EXPOSE 443

VOLUME ["/home/git/data"]

ENTRYPOINT ["/app/init"]
CMD ["app:start"]
