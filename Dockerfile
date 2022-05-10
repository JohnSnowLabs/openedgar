from ubuntu:16.04

RUN apt -y update
RUN apt -y upgrade
RUN apt -y install libssl-dev openssl make gcc
RUN apt -y install wget
RUN apt -y install build-essential python3-dev python3-pip virtualenv
RUN apt -y install build-essential virtualenv
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
RUN apt -y update
RUN apt -y install openjdk-8-jdk
RUN apt -y install git
RUN apt -y install vim

RUN echo "Building OpenEdgar from source............."
COPY ./ /opt/openedgar
#RUN cd /opt && git clone https://github.com/josejuanmartinez/openedgar.git
RUN cd /opt/openedgar && virtualenv -p /usr/bin/python3 env
RUN cd /opt/openedgar && ./env/bin/pip install -r lexpredict_openedgar/requirements/full.txt

COPY sample.env /opt/openedgar/lexpredict_openedgar/.env
COPY entrypoint.sh /opt/openedgar/entrypoint.sh
RUN chmod a+x /opt/openedgar/entrypoint.sh
EXPOSE 8000
ENTRYPOINT ["/opt/openedgar/entrypoint.sh"]
WORKDIR /opt/openedgar
