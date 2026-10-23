import LifeData
import LifeDomain

/// Isolate the three reviewed narrative contracts from opportunity sampling.
/// The production 40-event pool is exercised separately by EventSelectionTests and RNGV2Tests.
func legacyStoryFixture() throws -> ModelCatalog {
    var catalog = try StatisticsRepository.bundled()
    catalog.decisions.removeAll { !$0.isFallback }
    for index in catalog.decisions.indices {
        catalog.decisions[index].selection.minimumAge = catalog.decisions[index].age
        catalog.decisions[index].selection.maximumAge = catalog.decisions[index].age
    }
    try catalog.validate()
    return catalog
}
