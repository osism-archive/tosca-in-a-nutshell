.. _elk_dummy_section:

*************
ELK_DUMMYLOGS
*************

This topology templates can be can be used to test an ELK chain with some generated log data. It uses the DummyLogs sample Ystia components.

.. contents::
    :local:
    :depth: 3


Import Components and Topology template
----------------------------------------

  This step may be skipped in case you use Alien4Cloud's git integration for CSARs management

Upload the following Ystia components' CSARs to the Alien4Cloud catalog, and respect the order in the list:

#. **common**
#. **consul**
#. **java**
#. **kafka**
#. **elasticsearch**
#. **logstash**
#. **kibana**
#. **dummylogs**

Upload the **elk_dummylogs** topology archive to the Alien4Cloud Topology template catalog.

Topology template
-----------------
The **elk_dummylogs** template provides the following configuration:

- Relationships between the ELK components are created.

- ELK components are designed to be deployed on Compute hosts and appropriate Java distribution.

- Consul allows Elasticsearch cluster discovery.

- A compute hosting the DummyLogsGenerator component and a FileBeat component, both pre-configured to share the logs file. A relationship is created between FileBeat and Logstash.

- The kibana node is hosting the DummyLogsDashboard


Create an application
---------------------
The application can be created via the Alien4Cloud GUI using the **elk_dummylogs** topology shown below:

.. image:: docs/images/elk_dummylogs_topo.png
   :name: elk_dummylogs_figure
   :scale: 100
   :align: center

Complete configuration
----------------------

- You will need to upload a **Logstash** configuration file using **filter_conf** artifact. Use the logstash-dummylogs-filters.conf file, located the config repository of the Dummylogs Ystia component.

Deploy application and when the application is running, connect to Kibana using the **url** output attribute, then open the DummyLogs_V5 dashboard.