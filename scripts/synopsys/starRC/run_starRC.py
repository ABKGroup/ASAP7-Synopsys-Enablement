import os
import shutil
import subprocess

DESIGN = os.environ["DESIGN"]
CC = os.environ["CC"]

HOME_DIR = "../../.."
PDK_DIR = f"{HOME_DIR}/ASAP7"
DESIGN_DIR = f"{HOME_DIR}/benchmark/{DESIGN}"

CC_FLAG = "YES" if CC == "false" else "NO" ;# From Synopsys Reference

### For replacement ###
DEF_FILE = f"{DESIGN_DIR}/{DESIGN}.def"
NXTGRD_FILE = f"{PDK_DIR}/tlup/asap7_1x.nxtgrd"
LAYERMAP = f"{PDK_DIR}/tlup/asap7.layermap"
SPEF_FILE = f"{DESIGN_DIR}/{DESIGN}_STRC_CC_{CC}.spef"
RUN_DIR = f"{DESIGN}/CC_{CC}"

os.makedirs(RUN_DIR, exist_ok=True)

with open("ref_cmd", "r") as f:
    read_lines = f.readlines()

replacements = {
    "__DESIGN__": DESIGN,
    "__DEF_FILE__": DEF_FILE,
    "__LAYERMAP__": LAYERMAP,
    "__NXTGRD_FILE__": NXTGRD_FILE,
    "__SPEF_FILE__": SPEF_FILE,
    "__CC__": CC_FLAG, 
    "__RUN_DIR__": RUN_DIR
}

write_lines = []
for line in read_lines:
    for key, value in replacements.items():
        line = line.replace(key, value)
    write_lines.append(line)

with open("run_starRC", "w") as f:
    f.writelines(write_lines)

if shutil.which("StarXtract") is None:
    raise RuntimeError("StarXtract not found in PATH. Load StarRC environment first.")

subprocess.run(["StarXtract", "-clean", "run_starRC"], check=True)

if not os.path.exists(SPEF_FILE):
    raise RuntimeError(f"StarXtract completed but SPEF was not generated: {SPEF_FILE}")

os.remove("run_starRC")
star_sum = f"{DESIGN}.star_sum"
if os.path.exists(star_sum):
    os.remove(star_sum)
if os.path.isdir(RUN_DIR):
    shutil.rmtree(RUN_DIR)
