#!/bin/bash
sed -i '' 's/case .lantern: LanternIllustration()/case .lantern: Image("illustration_guidance").resizable().scaledToFit().padding(32)\n                                        case .twoFigures: Image("illustration_companion").resizable().scaledToFit().padding(32)\n                                        case .staircase: Image("illustration_journey").resizable().scaledToFit().padding(32)/g' Safe-Handz/Views/PreOnboarding/SwipeCardsView.swift
sed -i '' '/case .twoFigures: TwoFiguresIllustration()/d' Safe-Handz/Views/PreOnboarding/SwipeCardsView.swift
sed -i '' '/case .staircase: StaircaseIllustration()/d' Safe-Handz/Views/PreOnboarding/SwipeCardsView.swift
