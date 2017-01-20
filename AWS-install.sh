# ubuntu/images/hvm/ubuntu-wily-15.10-amd64-server-20160222 (ami-05384865)

set -x
set -e

sudo apt-get -y update
sudo apt-get -y install r-base python3-matplotlib libzmq3-dev python3.5-dev texlive-latex-extra texlive-latex-recommended python3-virtualenv

cd ~/
python3 -m virtualenv -p python3.5 env --system-site-packages
. ~/env/bin/activate

pip3 install -U jupyter jupyter_client ipython pandas

jupyter notebook --generate-config

cat >>/home/ubuntu/.jupyter/jupyter_notebook_config.py <<EOF
c = get_config()
c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False
c.NotebookApp.password = u'sha1:5d813e5d59a7:b4e430cf6dbd1aad04838c6e9cf684f4d76e245c'
c.NotebookApp.port = 8000

EOF

cd
cat >run-notebook.sh <<EOF
#! /bin/bash
. ~ubuntu/env/bin/activate
jupyter notebook
EOF

chmod +x run-notebook.sh

echo @reboot /home/ubuntu/run-notebook.sh | crontab
