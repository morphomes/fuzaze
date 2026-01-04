#!/bin/bash

# Prompt for title if not provided as argument
if [ $# -eq 0 ]; then
    read -p "Enter post title: " title
else
    title="$*"
fi

# Validate input
if [ -z "$title" ]; then
    echo "❌ Error: Title cannot be empty."
    exit 1
fi

# Create content/posts if it doesn't exist
mkdir -p content/posts

# Convert title to slug: lowercase, hyphens, no special chars
slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr -s ' ' '-' | tr -cd 'a-z0-9-')

# Remove leading/trailing hyphens
slug=$(echo "$slug" | sed 's/^-//' | sed 's/-$//')

# Get today's date
date=$(date +%Y-%m-%d)

# Build filename
filename="${date}-${slug}.md"
filepath="content/posts/${filename}"

# Handle duplicates
counter=1
original_filename="$filename"
while [ -e "$filepath" ]; do
    echo "⚠️ File exists: $filename"
    filename="${date}-${slug}-${counter}.md"
    filepath="content/posts/${filename}"
    ((counter++))
done

if [ "$filename" != "$original_filename" ]; then
    echo "📝 Using: $filename"
fi

# Generate front matter
{
    echo "---"
    echo "title: \"$title\""
    echo "date: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    echo "draft: true"
    echo "---"
    echo ""
} > "$filepath"

echo "✅ Created: $filepath"
echo "✏️  Set 'draft: false' when ready to publish!"