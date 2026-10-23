import pathlib, tempfile, shutil, subprocess, json, hashlib
source = pathlib.Path(__file__).resolve().parents[3]
evidence = pathlib.Path(__file__).resolve().parent; evidence.mkdir(exist_ok=True)
mutations = [
    ('unsorted-selection', 'let sorted = candidates.sorted { $0.eventID < $1.eventID }', 'let sorted = candidates', 'testWeightedSelectionIsOrderInvariantAndRespectsGrossOneToThreeRatio'),
    ('cooldown-off-by-one', 'met: state.age - last.age >= event.policy.cooldownYears', 'met: state.age - last.age > event.policy.cooldownYears', 'testOnceOnlyCooldownBoundaryAndMutualExclusionAreSeparateRules'),
    ('relationship-ignored', 'String(present), recorded.map { $0.present == present } ?? false)', 'String(present), true)', 'testEarlierChoiceUnlocksLaterActionWithRealProvenanceAndSameSeed')
]
with tempfile.TemporaryDirectory(prefix='lc-rng-mutation-') as folder:
    folder = pathlib.Path(folder)
    shutil.copy2(source/'Package.swift', folder/'Package.swift')
    for item in ['LifeCrossroads/Domain', 'LifeCrossroads/Data', 'LifeCrossroads/CLI', 'Tests/LifeDomainTests']:
        shutil.copytree(source/item, folder/item)
    target = folder/'LifeCrossroads/Domain/EventDirector.swift'
    original = target.read_text()
    rows = []
    for name, before, after, method in mutations:
        assert original.count(before)==1, name
        target.write_text(original.replace(before, after))
        command = ['swift','test','--filter',f'EventDirectorTests/{method}']
        with (evidence/f'{name}.log').open('w') as log:
            result = subprocess.run(command, cwd=folder, stdout=log, stderr=subprocess.STDOUT)
        log = (evidence/f'{name}.log').read_text()
        rows.append({'mutation':name,'test':method,'exit_code':result.returncode,
                     'detected_by_test_assertion':result.returncode != 0 and "Test Suite 'EventDirectorTests' failed" in log,
                     'log':str(evidence/f'{name}.log')})
        target.write_text(original)
    report = {'production_file':'LifeCrossroads/Domain/EventDirector.swift','sha256':hashlib.sha256(original.encode()).hexdigest(),
              'isolated_copy':True,'shared_worktree_modified':False,'mutations':rows,'temporary_copy_deleted_on_exit':True}
    (evidence/'summary.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2))
