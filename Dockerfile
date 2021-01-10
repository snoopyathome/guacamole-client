FROM tomcat:8.0.20-jre7

ENV GUAC_VERSION=0.9.9
ENV GUAC_JDBC_VERSION=0.9.9

COPY files/deploy.sh /deploy.sh
COPY files/start.sh /start.sh

RUN chmod +x /deploy.sh && chmod +x /start.sh

RUN /deploy.sh

CMD ["/start.sh" ]
