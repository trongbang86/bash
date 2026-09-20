import sys, re

text = sys.stdin.read()

# Named replacements (order matters — do these before generic stripping)
replacements = [
    ('\u2705', '(Passed)'),   # ✅ green tick / check mark
    ('\u274c', '(Failed)'),   # ❌ red cross
    ('\u274e', '(Failed)'),   # ✖ cross mark
    ('\u26a0', '(Warning)'),  # ⚠ warning
    ('\u2757', '(!)'),        # ❗ exclamation
    ('\u2139', '(i)'),        # ℹ information
    ('\u23f3', '(pending)'),  # ⏳ hourglass
    ('\u2714', '(Passed)'),   # ✔ heavy check mark
    ('\u2716', '(Failed)'),   # ✖ heavy multiplication x
    ('\u25cf', '*'),          # ● black circle
    ('\u2192', '->'),         # → right arrow
    ('\u2190', '<-'),         # ← left arrow
    ('\u2014', '-'),          # — em-dash
    ('\u2013', '-'),          # – en-dash
    ('\u00d7', 'x'),          # × multiplication sign
    ('\u00b7', '.'),          # · middle dot
]
for icon, label in replacements:
    text = text.replace(icon, label)

# Strip emoji/symbol blocks — skip U+2500-U+25FF (box-drawing, block elements)
# and U+2300-U+23FF (misc technical like ⏎ ⌛) which may appear in table/terminal output
text = re.sub(r'[\U0001F000-\U0001FFFF\U00002600-\U000027BF\U0000FE00-\U0000FE0F\U0001F300-\U0001FAFF\U0001FA00-\U0001FFFF]+', '', text)
# Remove zero-width joiners and variation selectors
text = re.sub(r'[\u200d\ufe0f\u20e3]', '', text)

sys.stdout.write(text)
