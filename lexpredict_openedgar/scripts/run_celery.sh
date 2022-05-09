source ../env/bin/activate
source .env
C_FORCE_ROOT=1 celery -A lexpredict_openedgar.taskapp worker --loglevel=ERROR -f celery.log -c16
