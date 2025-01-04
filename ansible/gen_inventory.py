import configparser
import subprocess

server_ip_address = subprocess.run(["cd", "../terraform", "&", "terraform", "output"], shell=True)

config = configparser.ConfigParser()
config["database"] = {"postgresql1": ""}
config["database:vars"] = {
    "ansible_host": server_ip_address.stdout.split("=")[-1].strip(),
    "ansible_user": "ansible"
}
with open("hosts.ini", "w") as inventory:
    config.write(inventory)
