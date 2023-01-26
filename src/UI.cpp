#include "UI.h"

#include <utility>

namespace kxWhereAreYou::UI {

    namespace Messages {
        class MessageBoxResultCallback : public RE::IMessageBoxCallback {
            std::function<void(unsigned int)> _callback;
        public:
            ~MessageBoxResultCallback() override = default;
            explicit MessageBoxResultCallback(std::function<void(unsigned int)> callback) : _callback(std::move(callback)) {}
            void Run(RE::IMessageBoxCallback::Message message) override { _callback(static_cast<unsigned int>(message)); }
        };

        void Show(const std::string& bodyText, const std::vector<std::string>& buttonTextValues, const std::function<void(unsigned int)>& callback) {
            auto* factoryManager = RE::MessageDataFactoryManager::GetSingleton();
            auto* uiStringHolder = RE::InterfaceStrings::GetSingleton();
            auto* factory = factoryManager->GetCreator<RE::MessageBoxData>(uiStringHolder->messageBoxData);
            auto* messagebox = factory->Create();
            RE::BSTSmartPointer<RE::IMessageBoxCallback> messageCallback = RE::make_smart<MessageBoxResultCallback>(callback);
            messagebox->callback = messageCallback;
            messagebox->bodyText = bodyText;
            for (const auto& text : buttonTextValues) messagebox->buttonText.push_back(text.c_str());
            messagebox->QueueMessage();
        }
    }

    namespace Console {
        void Print(std::string text) {
            RE::ConsoleLog::GetSingleton()->Print(text.c_str());
            logger::debug("{}", text);
        }

        void SelectReference(RE::TESObjectREFR* reference) {
            using Message = RE::UI_MESSAGE_TYPE;

            if (reference) {
                const auto factory = RE::MessageDataFactoryManager::GetSingleton();
                const auto intfcStr = RE::InterfaceStrings::GetSingleton();
                const auto creator =
                    factory && intfcStr ? factory->GetCreator<RE::ConsoleData>(intfcStr->consoleData) : nullptr;

                const auto consoleData = creator ? creator->Create() : nullptr;
                const auto msgQ = RE::UIMessageQueue::GetSingleton();
                if (consoleData && msgQ) {
                    consoleData->type = static_cast<RE::ConsoleData::DataType>(1);
                    consoleData->pickRef = reference->CreateRefHandle();
                    msgQ->AddMessage(intfcStr->console, Message::kUpdate, consoleData);
                }
            } else {
                const auto ui = RE::UI::GetSingleton();
                const auto console = ui ? ui->GetMenu<RE::Console>() : nullptr;
                if (console) {
                    const RE::ObjectRefHandle null;
                    console->SetSelectedRef(null);
                }
            }
        }
    }
}
