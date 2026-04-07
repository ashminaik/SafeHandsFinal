#!/bin/bash
sed -i '' 's/case .lantern: LanternIllustration()/case .lantern: Image("illustration_journey").resizable().scaledToFit().padding(16)/g' Safe-Handz/Views/PreOnboarding/SwipeCardsView.swift
sed -i '' 's/Image("illustration_companion").resizable().scaledToFit().padding(32)/Image("illustration_companion").resizable().scaledToFit().padding(16)/g' Safe-Handz/Views/PreOnboarding/SwipeCardsView.swift
sed -i '' 's/Image("illustration_family_walk").resizable().scaledToFit().padding(32)/Image("illustration_family_walk").resizable().scaledToFit().padding(16)/g' Safe-Handz/Views/PreOnboarding/SwipeCardsView.swift
