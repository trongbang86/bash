import json, sys, os

key = sys.argv[1]
path = os.path.expanduser('~/.claude/settings.json')
with open(path) as f:
    d = json.load(f)
d.setdefault('env', {})['ANTHROPIC_AUTH_TOKEN'] = key
with open(path, 'w') as f:
    json.dump(d, f, indent=2)
    f.write('\n')
print('API key updated in settings.json')
