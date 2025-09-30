# Minimal Makefile for Flutter automation (Windows friendly)

FLUTTER = flutter
PUB = $(FLUTTER) pub

.PHONY: all get clean gen locale splash splash-remove setup help

all: get gen locale splash

get:
	@echo "➡️  Getting dependencies..."
	$(PUB) get

clean:
	@echo "🧹 Cleaning..."
	$(FLUTTER) clean
	@if exist build rmdir /s /q build

gen:
	@echo "⚙️  Generating code..."
	flutter pub run build_runner build --delete-conflicting-outputs

locale:
	@echo "🌍 Generating localization keys..."
	dart run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations

splash:
	@echo "🖼  Generating native splash screen..."
	flutter pub run flutter_native_splash:create

splash-remove:
	@echo "❌ Removing native splash screen..."
	flutter pub run flutter_native_splash:remove

setup: clean get gen locale splash

refresh: clean get

help:
	@echo ""
	@echo "🚀 Flutter Makefile Commands:"
	@echo "  make get            – flutter pub get"
	@echo "  make clean          – flutter clean + clear build/"
	@echo "  make gen            – run build_runner"
	@echo "  make locale         – generate EasyLocalization keys"
	@echo "  make splash         – generate native splash screen"
	@echo "  make splash-remove  – remove native splash screen"
	@echo "  make setup          – full clean/build/setup including splash"
	@echo "  make all            – get + gen + locale + splash (default)"
