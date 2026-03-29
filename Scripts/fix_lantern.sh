#!/bin/bash
sed -i '' 's/case .lantern: Image("illustration_guidance").resizable().scaledToFit().padding(32)/case .lantern: LanternIllustration()/g' Safe-Handz/Views/PreOnboarding/SwipeCardsView.swift
