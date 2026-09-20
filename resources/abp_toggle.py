import sys

profile_path = sys.argv[1]
cmds = sys.argv[2:]

enabled_suffix = "# abp.toggle - Enabled"
disabled_prefix = "# abp.toggle - DISABLED - "

with open(profile_path) as f:
    lines = f.readlines()

found_states = []
new_lines = []
for line in lines:
    stripped = line.rstrip('\n')
    matched = False
    for cmd in cmds:
        if stripped == f"{cmd} {enabled_suffix}":
            found_states.append('enabled')
            matched = True
            break
        elif stripped == f"{disabled_prefix}{cmd}":
            found_states.append('disabled')
            matched = True
            break
    if not matched:
        new_lines.append(line)

if not found_states:
    print(f"ERROR: no toggle lines found in {profile_path}")
    sys.exit(1)

# If any line is enabled, disable all; otherwise enable all
action = 'disable' if 'enabled' in found_states else 'enable'

while new_lines and new_lines[-1].strip() == '':
    new_lines.pop()

for cmd in cmds:
    if action == 'disable':
        out = f"{disabled_prefix}{cmd}"
    else:
        out = f"{cmd} {enabled_suffix}"
    new_lines.append(out + '\n')
    print(f"{'DISABLED' if action == 'disable' else 'ENABLED'}: {out}")

with open(profile_path, 'w') as f:
    f.writelines(new_lines)
