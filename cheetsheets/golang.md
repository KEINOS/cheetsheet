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

[[Back to top](#)]<!-- ---------------------------------------------- -->

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

[[Back to top](#)]<!-- ---------------------------------------------- -->

## How to get content like `cURL`

```go
response, err := http.Get(c.EndpointURL)
if err != nil {
  return nil, errors.Wrap(err, "failed to GET HTTP request")
}

defer response.Body.Close()

// Read responce body
resBody, err := io.ReadAll(response.Body)
if err != nil {
  return nil, errors.Wrap(err, "fail to read response")
}

if response.StatusCode != http.StatusOK {
  return nil, errors.Errorf(
    "fail to GET response from: %v\nStatus: %v\nResponse body: %v",
    c.EndpointURL,
    response.Status,
    string(resBody),
  )
}

fmt.Println(string(resBody))
```

[[Back to top](#)]<!-- ---------------------------------------------- -->

## How to return error response in httptest.NewServer during test

```go
dummySrv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, req *http.Request) {
    w.WriteHeader(http.StatusBadRequest)
    fmt.Fprintf(w, "invalid request")

    // return is not needed. it will be redundant
}))
defer dummySrv.Close()
```

[[Back to top](#)]<!-- ---------------------------------------------- -->

## How to sleep a second

```go
time.Sleep(1 * time.Second)
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

[[Back to top](#)]<!-- ---------------------------------------------- -->

## How to benchmark

```go
func BenchmarkAppend_AllocateEveryTime(b *testing.B) {
    base := []string{}

    b.ResetTimer()
    // b.N is the number of iterations given from the benchmarking tool.
    for i := 0; i < b.N; i++ {
        base = append(base, fmt.Sprintf("no%d", i))
    }
}
```

```shellsession
$ go test -bench . -benchmem
...
```

```bash
# Options
-benchmem ............ Print memory allocations
-benchtime t ......... Iterate for t seconds. Default 1s.
-cpuprofile=*.prof ... Detaild CPU profiling information. Viewable with `go tool pprof`.
-count ............... Number of test iterations to run.
-cpu ................. Number of CPUs to use.
-memprofile=*.mem .... Detailed memory profiling information. Viewable with `go tool pprof`.
```

[[Back to top](#)]<!-- ---------------------------------------------- -->

## How to generate 1MBytes of consistent data for testing

```go
// inputData holds 1MB(1e6) size of data created by testData() function.
var inputData []byte

// The testData creates 1,000,000 bytes= 1MB (1e6) size of data.
// The returned values are consistent and not random.
func testData(b *testing.B) []byte {
	b.Helper()

  // use initialized data
	if len(inputData) != 0 {
    return inputData
  }

	// Initialize data
  inputData = make([]byte, 1e6)

  for i := range inputData {
    // Custom this line to generate different data
    inputData[i] = byte(i % 251)
  }

	return inputData
}
```

[[Back to top](#)]<!-- ---------------------------------------------- -->

## How to check if file exists

```go
func fileExists(path string) bool {
    _, err := os.Stat(path)

    return !errors.Is(err, os.ErrNotExist)
}
```

If you want to check if a file exists before opening it, you don't need
to check the path before opening it.

The below opens a file if it exists, otherwise it creates a new one.

```go
f, err := os.OpenFile(pathFile, os.O_RDWR|os.O_CREATE|os.O_EXCL, 0666)
if errors.Is(err, os.ErrNotExist) {
  ...
}
```

[[Back to top](#)]<!-- ---------------------------------------------- -->
