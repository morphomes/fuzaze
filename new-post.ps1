param(
    [Parameter(Mandatory=$false)]
    [string]$Title
)

$SiteRoot = $PSScriptRoot
$PostsDir = Join-Path $SiteRoot "content" "posts"

if (!(Test-Path $PostsDir)) {
    New-Item -ItemType Directory -Path $PostsDir | Out-Null
    Write-Host "📁 Created content/posts directory." -ForegroundColor Green
}

if ([string]::IsNullOrWhiteSpace($Title)) {
    $Title = Read-Host "Enter post title"
    if ([string]::IsNullOrWhiteSpace($Title)) {
        Write-Host "❌ No title provided. Exiting." -ForegroundColor Red
        exit 1
    }
}

# Clean title to slug
$Slug = $Title.Trim() -replace '[^a-zA-Z0-9\s-]', ''
$Slug = $Slug -replace '\s+', '-'
$Slug = $Slug.Trim('-').ToLower()

$Date = Get-Date -Format "yyyy-MM-dd"
$Filename = "$Date-$Slug.md"
$FilePath = Join-Path $PostsDir $Filename

# Handle duplicates
if (Test-Path $FilePath) {
    Write-Host "⚠️  File exists: $Filename" -ForegroundColor Yellow
    $counter = 1
    do {
        $NewFilename = "$Date-$Slug-$counter.md"
        $FilePath = Join-Path $PostsDir $NewFilename
        $counter++
    } while (Test-Path $FilePath)
    $Filename = $NewFilename
    Write-Host "📝 Using: $Filename" -ForegroundColor Cyan
}

# Build front matter without here-string (to avoid parsing issues)
$FrontMatter = "---`n"
$FrontMatter += "title: `"$Title`"`n"
$FrontMatter += "date: $(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssZ')`n"
$FrontMatter += "draft: true`n"
$FrontMatter += "---`n`n"

Set-Content -Path $FilePath -Value $FrontMatter -Encoding UTF8

Write-Host "✅ Created: $Filename" -ForegroundColor Green
Write-Host "✏️  Set 'draft: false' when ready to publish!" -ForegroundColor Cyan