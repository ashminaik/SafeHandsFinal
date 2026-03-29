#!/bin/bash
ASSETS_DIR="/Users/chirayugaur/Desktop/Safe-Handz/Safe-Handz/Assets.xcassets"

# 1. Create illustration_journey.imageset
mkdir -p "$ASSETS_DIR/illustration_journey.imageset"
mv "$ASSETS_DIR/illustration_family_walk.imageset/illustration_journey.png" "$ASSETS_DIR/illustration_journey.imageset/"
cat << 'EOF' > "$ASSETS_DIR/illustration_journey.imageset/Contents.json"
{
  "images" : [
    {
      "idiom" : "universal",
      "scale" : "1x"
    },
    {
      "idiom" : "universal",
      "scale" : "2x"
    },
    {
      "filename" : "illustration_journey.png",
      "idiom" : "universal",
      "scale" : "3x"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# 2. Create illustration_companion.imageset
mkdir -p "$ASSETS_DIR/illustration_companion.imageset"
mv "$ASSETS_DIR/illustration_family_walk.imageset/illustration_companion.png" "$ASSETS_DIR/illustration_companion.imageset/"
cat << 'EOF' > "$ASSETS_DIR/illustration_companion.imageset/Contents.json"
{
  "images" : [
    {
      "idiom" : "universal",
      "scale" : "1x"
    },
    {
      "idiom" : "universal",
      "scale" : "2x"
    },
    {
      "filename" : "illustration_companion.png",
      "idiom" : "universal",
      "scale" : "3x"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# 3. Fix the existing illustration_family_walk.imageset
cat << 'EOF' > "$ASSETS_DIR/illustration_family_walk.imageset/Contents.json"
{
  "images" : [
    {
      "idiom" : "universal",
      "scale" : "1x"
    },
    {
      "idiom" : "universal",
      "scale" : "2x"
    },
    {
      "filename" : "illustration_family_walk.png",
      "idiom" : "universal",
      "scale" : "3x"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF
