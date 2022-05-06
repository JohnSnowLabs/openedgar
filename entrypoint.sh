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
echo "Preparing Celery"
cd /opt/openedgar/lexpredict_openedgar
bash scripts/run_celery.sh &
echo "CELERY prepared"
echo "*********************SUCCESSFULLY PREPARED: LAUNCHING SERVER*****************"
python3 manage.py runserver 0.0.0.0:8000
echo "*********************************STOPPED*************************************"
