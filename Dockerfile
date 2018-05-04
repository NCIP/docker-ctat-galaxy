FROM bgruening/galaxy-stable

ENV GALAXY_CONFIG_BRAND "Trinity CTAT Galaxy"

WORKDIR /galaxy-central

RUN add-tool-shed --url 'http://testtoolshed.g2.bx.psu.edu/' --name 'Test Tool Shed'

ADD tool_list.yaml $GALAXY_ROOT/tool_list.yaml

COPY viz.tgz $GALAXY_ROOT/config/plugins/visualizations

RUN tar -xzvf $GALAXY_ROOT/config/plugins/visualizations/viz.tgz

COPY jsonDataProvider.py jsonDataProvider.py

RUN cat jsonDataProvider.py >> $GALAXY_ROOT/lib/galaxy/datatypes/dataproviders/dataset.py

RUN mv $GALAXY_ROOT/lib/galaxy/datatypes/text.py $GALAXY_ROOT/lib/galaxy/datatypes/text.bkp.py

COPY text.py $GALAXY_ROOT/lib/galaxy/datatypes/text.py

ADD dependency_resolvers_conf.xml $GALAXY_ROOT/dependency_resolvers_conf.xml

RUN install-tools $GALAXY_ROOT/tool_list.yaml

# General notes for Docker dealings:
#
#For my sanity
#sudo apt-get install emacs
#Install Docker the right way
#sudo apt-get remove docker docker-engine docker.io
#sudo apt-get update
#sudo apt-get install     apt-transport-https     ca-certificates     curl     software-properties-common
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#sudo apt-key fingerprint 0EBFCD88
#sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
#$(lsb_release -cs) \
#stable"
#sudo apt-get update
#sudo apt-get install docker-ce
#sudo docker run hello-world
#Create a space
#mkdir Dockergal
#cd Dockergal/
#Pull this github repo
#sudo docker build --no-cache -t my-docker-test .
#sudo docker run -i -t -p 80:80  my-docker-test /bin/bash
#Check running docker processes
#sudo docker ps
#Remove unneeded files
#sudo docker system prune