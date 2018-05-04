FROM bgruening/galaxy-stable

ENV GALAXY_CONFIG_BRAND "Trinity CTAT Galaxy"

WORKDIR /galaxy-central

RUN add-tool-shed --url 'http://testtoolshed.g2.bx.psu.edu/' --name 'Test Tool Shed'

ADD tool_list.yaml $GALAXY_ROOT/tool_list.yaml

##COPY discasm_tutorial.tgz discasm_tutorial.tgz
COPY jsonDataProvider.py jsonDataProvider.py

RUN cat jsonDataProvider.py >> $GALAXY_ROOT/lib/galaxy/datatypes/dataproviders/dataset.py

RUN mv $GALAXY_ROOT/lib/galaxy/datatypes/text.py $GALAXY_ROOT/lib/galaxy/datatypes/text.bkp.py

COPY text.py $GALAXY_ROOT/lib/galaxy/datatypes/text.py

ADD dependency_resolvers_conf.xml $GALAXY_ROOT/dependency_resolvers_conf.xml

RUN install-tools $GALAXY_ROOT/tool_list.yaml
