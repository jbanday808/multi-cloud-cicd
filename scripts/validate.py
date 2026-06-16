import subprocess
import sys

commands = [
    [sys.executable, "-m", "compileall", "app"],
    ["docker", "build", "-t", "multi-cloud-cicd:test", "."]
]

for command in commands:
    subprocess.run(command, check=True)

print("Validation Successful")
