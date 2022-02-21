[INDEX](../)

---

# Golang CheetSheet

This is a memorandum for KEINOS.

## Enum (Enumerable)

- Ref: [https://www.sohamkamani.com/golang/enums/](https://www.sohamkamani.com/golang/enums/)

```go
type Season int

const (
	Summer Season = iota
	Autumn
	Winter
	Spring
)

func (s Season) String() string {
	switch s {
	case Summer:
		return "summer"
	case Autumn:
		return "autumn"
	case Winter:
		return "winter"
	case Spring:
		return "spring"
	}

    return "unknown"
}

func printSeason(s Season) {
	fmt.Println("season: ", s)
}

func main() {
	i := Summer
	printSeason(i)
}
```

## Get imported module's version from the code

```go
mods := []*debug.Module{}

if buildInfo, ok := debug.ReadBuildInfo(); ok {
  mods = buildInfo.Deps
}

if len(mods) == 0 {
  dummyMod := &debug.Module{
    Path:    "n/a",
    Version: "n/a",
    Sum:     "n/a",
  }

  mods = []*debug.Module{
    dummyMod,
  }
}

getModName := func(modDep *debug.Module) string {
  // module name without leading version in a path
  noVer := strings.ReplaceAll(modDep.Path, "/"+modDep.Version, "")

  return filepath.Base(noVer)
}

modsFound := map[string]debug.Module{}

for _, modDep := range mods {
  name := getModName(modDep)
  modsFound[name] = *modDep
}

return modsFound
```

## Field Names/Variables of GoReleaser

List of available field names in GoReleaser's config file. Such as `{{ .Version }}` `{{ .Tag }}`, for example.

- [Name Templates](https://goreleaser.com/customization/templates/) @ goreleaser.com

```yaml
# =============================================================================
#  Configuration of goreleaser for go-multihash
# =============================================================================
#  For local-test run:
#    $ goreleaser release --snapshot --skip-publish --rm-dist
#    $ # *Note: Check the ./dist/ dir after ran.
#
#  Make sure to check the documentation as well at:
#    https://goreleaser.com/customization/
# =============================================================================
before:
  hooks:
    - go mod download
# Name to use on test release with --snapshot option.
snapshot:
  name_template: '{{ .Version }}'

# Settings to build the binaries.
builds:
  -
    # Target directory of main.go
    main: ./cmd/multihash
    # Output binary name
    binary: multihash
    env:
      - CGO_ENABLED=0
    # Target OS
    goos:
      - linux
      - darwin
    # Target architectures
    goarch:
      - amd64
      - arm
      - arm64
    # Variant for ARM32
    goarm:
      - "5"
      - "6"
      - "7"
    # Ignore ARM32/ARM64 build for both macOS and Windows
    ignore:
      - goos: darwin
        goarch: arm
    # Build the app as static binary and embed version and commit info
    ldflags:
      - -s -w -extldflags '-static' -X 'main.version={{ .Version }}' -X 'main.tag={{ .Tag }}'

# macOS universal binaries for both arm64 and amd64
universal_binaries:
  -
    name_template: 'multihash'
    # Combine arm64 and amd64 as a single binary and remove each
    replace: true

# Archiving the built binaries
archives:
  -
    replacements:
      darwin: macOS
      linux: Linux
    format_overrides:
      - goos: darwin
        format: zip

# Create checksum file of archived files
checksum:
  name_template: 'checksums.txt'

# Release/update Homebrew tap repository
brews:
  -
    # Name of the package: multihash.rb
    name: multihash
    # Target repo to tap: KEINOS/homebrew-apps
    tap:
      owner: KEINOS
      name: homebrew-apps
    # Target directory: KEINOS/homebrew-apps/Formula
    folder: Formula
    # URL of the archive in releases page
    url_template: "https://github.com/KEINOS/go-multihash/releases/download/{{ .Tag }}/{{ .ArtifactName }}"
    # Author info to commit to the tap repo
    commit_author:
      name: goreleaserbot
      email: goreleaser@carlosbecker.com
    # Message to display on `brew search` or `brew info`
    description: "Multihash is a command that returns a self-explanatory hash value."
    homepage: "https://github.com/KEINOS/go-multihash/"
    # Let brew command pull the archive via cURL
    download_strategy: CurlDownloadStrategy
    # Let brew command instll the binary as `go-pallet`
    install: |
      bin.install "multihash"
    # Smoke test to run after install
    test: |
      system "#{bin}/multihash -h"
```
