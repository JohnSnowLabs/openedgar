# Docker installation
Make sure you have Docker and Docker-compose installed.

1) Clone John Snow Labs OpenEdgar git repo from any of these sources:
   1) `git clone https://github.com/JohnSnowLabs/openedgar`, or...
   2) `git clone https://github.com/josejuanmartinez/openedgar`
2) Execute `sudo docker-compose up -d` to start containers from the following images:
   1) Postgres (latest)
   2) RabbitMQ (latest)
   3) 2 different Postgres DB visualizers: `pgadmin4` and `adminer`
   4) OpenEdgar

The docker-compose will create a persistent volumes for everything: the database and the txt.
So you can just spin on and off the containers as you need to scrap new documents.

# Scraping new documents
After step 2, you will have 4 containers available. We need to get into the OpenEdgar and execute a couple of commands.
1) Execute `sudo docker exec -it openedgar_openedgar_1 /bin/bash`
2) Once inside the container, activate the environment: `source source_me.sh`
3) Start OpenEdgar console: `bash start.sh`
    1) Import these libraries
   ```
   from openedgar.processes.edgar import download_filing_index_data, process_all_filing_index
   ```
   2) Download all the filing documents from 2022 year using `year` parameter
   ```
   download_filing_index_data(year=2022)
   ```
   3) Parse them (set `store_raw`False` and `store_text=True` to only store txt, and not other formats as xml)
   ```
   process_all_filing_index(year=2022, store_raw=False, store_text=True) 
   ```
   Alternatively, you can parse specific document types with `form_type_list` parameter
   ```
   process_all_filing_index(year=2022, store_raw=False, store_text=True, form_type_list=["10-K"])
   ```
   4) If your work for any reason crashes, you can restore your work by starting from the last record obtained
   with the `new_only` parameter
   ```
   process_all_filing_index(year=2022, store_raw=False, store_text=True, form_type_list=["10-K"], new_only=True)
   ```
Check the Docker-compose logs to see the output of the processing step using the following command:
```
sudo docker logs -f openedgar_openedgar_1
```
If the log is not showing anything new, then the processing has finished and you can proceed to retrieve your documents or results from database. 

## Sample times
Sample timing on m5.large (2 core, 8GB RAM): ~24 hours to retrieve and parse all 2018 10-Ks

# Checking the results
## Database
Open adminer (http://localhost:8080) or PgAdmin (http://localhost:333). You can check for the username and password in the docker-compose file. Please, make sure to change them and include additional authentication steps.
The relevant tables are:
```
openedgar_company
openedgar_companyinfo
openedgar_filing
openedgar_filingdocument
openedgar_filingindex
```



## Documents
All documents will be available in the persistent volume created in the docker-compose for OpenEdgar (`docker volume ls` or `docker volume inspect openedgar`)
The txt files will be available inside the volume, in `data/` directory.

In the database, you will find the table `filing_documents`
