#include "Logging.h"
#include "Papyrus.h"
#include "Settings.h"

using namespace kxWhereAreYou;

SKSEPluginLoad([[maybe_unused]] const SKSE::LoadInterface* skse) {
    SKSE::Init(skse);
    Logging::Setup();
    Papyrus::Setup();
    Settings::Setup();
    logger::info("{} initialized!", SKSE::PluginDeclaration::GetSingleton()->GetName());
    return true;
}
