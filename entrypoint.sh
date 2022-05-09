#!/bin/bash
cd /opt/openedgar/lexpredict_openedgar
source /opt/openedgar/env/bin/activate
source .env
echo "Preparing the database (migrate)"
python3 manage.py migrate
echo "Migrated"
echo "Preparing TIKA"
cd /opt/openedgar/tika
bash download_tika.sh
bash run_tika.sh &
echo "TIKA prepared"
echo "Running Celery [FINAL STEP]"
cd /opt/openedgar/lexpredict_openedgar
bash /opt/openedgar/lexpredict_openedgar/scripts/run_celery.sh
