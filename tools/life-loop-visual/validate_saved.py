#!/usr/bin/env python3
"""Check exported native fixture records against reviewed scenario invariants.

These checks concern the isolated renderer and genuine save round trip only;
they do not validate the App playback controller or production integration.
"""
import argparse
import json
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('runs', nargs='+', type=Path)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    checks = []
    pending_count = 0

    def check(name, condition):
        checks.append({'name': name, 'passed': bool(condition)})
        if not condition:
            raise AssertionError(name)

    for run in args.runs:
        records = {}
        for mode, age in [('offline', 13), ('rest', 13), ('ask', 13), ('adult', 39), ('child', 8)]:
            source = json.loads((run / 'saved-sources' / f'{mode}-source.json').read_text())
            save = json.loads((run / 'saved-sources' / f'{mode}-save.json').read_text())
            check(f'{run.name}/{mode}: exported session matches actual saved bytes',
                  source['session'] == save['journey']['single']['_0'])
            check(f'{run.name}/{mode}: authoritative age and pinned contract',
                  source['age'] == age and source['session']['state']['age'] == age
                  and source['contractCommit'] == '7040802846d8829ca969d98ff7023d51fb11913d')
            records[mode] = source
            for change in source['changes']:
                if not change['isOccurred']:
                    pending_count += 1
                    check(f'{run.name}/{mode}: unoccurred clue is not a success symbol',
                          change['symbol'] == 'clock.badge.questionmark')

        # Reviewed teen-project fixture: offline records paper learning and teacher
        # interaction; rest records no learning and no teacher interaction.
        for mode, symbol in [('offline', 'book.closed'), ('rest', 'leaf')]:
            memory = [c for c in records[mode]['changes']
                      if c['kind'] == 'memory' and c['sourceEventID'] == 'teen-project']
            check(f'{run.name}/{mode}: distinct recorded activity marker',
                  len(memory) == 1 and memory[0]['symbol'] == symbol
                  and memory[0]['sourceChoiceID'] == mode and memory[0]['isOccurred'])
        check(f'{run.name}: paper includes recorded teacher; rest excludes teacher',
              any(a['personID'] == 'teacher' and a['role'] == 'interacted' for a in records['offline']['actors'])
              and not any(a['personID'] == 'teacher' for a in records['rest']['actors']))

    result = {'checks': checks, 'passed': all(c['passed'] for c in checks),
              'pending_clues_exercised': pending_count,
              'pending_boundary': 'exercised' if pending_count else 'NOT EXERCISED in these fixed seeds',
              'scope': 'Native isolated saved-session renderer; not formal App/clock, GameStore failure handling, G1-G6, or human review'}
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
    print(f'{len(checks)} saved-source checks passed; pending cases exercised: {pending_count}')


if __name__ == '__main__':
    main()
