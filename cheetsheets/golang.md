[INDEX](../)

---

# Golang CheetSheet

This is a memorandum for KEINOS.

## Generate rowID and tableID for Key-Value SQLite3

Example of creating the keys (`rowid` and table name) from the contens to use SQLite3 as a CAS (Content Addressable Storage).

```go
package main

import (
	"fmt"
	"math/big"

	"github.com/zeebo/blake3"
)

func Example() {
	for _, sample := range []string{
		"Hello World",
		"Hello World!",
		"Hello, world",
	} {
		rowID, tableID := GetIDs(sample)

		fmt.Println("RowID:", rowID)
		fmt.Println("TableID:", tableID)
	}
	// RowID: 4753612358325858618
	// TableID: table039
	// RowID: 6676447199849907433
	// TableID: table179
	// RowID: -124719410497300881
	// TableID: table218
}

// GetIDs returns a unique rowID and tableID combination from the given data.
//
// "rowID" is the first 8 bytes of BLAKE3-256 hash as signed decimal string.
// "tableID" is the 1 byte XOR checksum of the full hash as decimal string with
// "table" prefix (`table<xor sum>`).
func GetIDs(data string) (rowID, tableID string) {
	digest := blake3.Sum256([]byte(data))

	chksum := byte(0)
	for _, b := range digest {
		chksum ^= b
	}

	tableID = fmt.Sprintf("table%03d", chksum)

	trimmed := digest[:8]
	hashedInt := big.NewInt(0).SetBytes(trimmed).Int64()
	rowID = fmt.Sprintf("%d", hashedInt)

	return rowID, tableID
}
```

- [View it online](https://go.dev/play/p/jasq10eVQd_f) @ Go playground

## How to convert `bytes` to `int` (`[]byte --> int`)

```go
import "math/big"

b := []byte{0xFF, 0xFF, 0xFF} // 0d16777215 = 0xffffff
fmt.Printf("%X\n", b)

e := int(big.NewInt(0).SetBytes(b).Uint64())
fmt.Printf("%v\n", e)
// Output:
// FFFFFF
// 16777215
```

- [View it online](https://go.dev/play/p/UqsfcM1UTnH) @ Go Playground

## Random Numbers

```go
// Not cryptographically secure but fast.
import "math/rand"

rand.Seed(time.Now().UnixNano())

// Ger random number between 0 and 99.
num := int(100)

//nolint:gosec // not for cryptographical use
fmt.Println(rand.Intn(num))
```

```go
// Cryptographically secure random number but slower than math/rand.
import "crypto/rand"

// Ger random number between 0 and 99.
num := int64(100)

n, err := rand.Int(rand.Reader, big.NewInt(num))
if err != nil {
    panic(err)
}

fmt.Println(n)
```

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

## How to update all the packages(`go.mod` and `go.sum` to the latest)

```bash
go get -u ./...
go mod tidy
```

[[Back to top](#)]<!-- ---------------------------------------------- -->

## How to sleep a second

```go
time.Sleep(time.Second)
```

## How to sleep n seconds

```go
import "time"

sleepTime := time.Duration(5)
time.Sleep(time.time.Second * time.Duration(sec))
```

```go
func randSleep(secMax int) {
	if secMax == 0 {
		secMax = 1
	}
	// In case of secMax = 1, we get a random number between 0 and 999
	sec := randInt(secMax * 1000)

	time.Sleep(time.Millisecond * time.Duration(sec))
}
```

[[Back to top](#)]<!-- ---------------------------------------------- -->

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

## How to install benchstat

- [golang.org/x/perf/cmd/benchstat](https://pkg.go.dev/golang.org/x/perf/cmd/benchstat)

```go
go install "golang.org/x/perf/cmd/benchstat@latest"
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
$ go test -bench . -benchmem > bench.txt
...
$ benchstat ./bench.txt
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

## How to write gigantic data to a file

For huge amount of data, instead of using directly `os.File.Write()` method, use `bufio.Writer` in-between to write data in chunks to speed up the process.

```go
	fileP, err := os.Create(pathFile)
	if err != nil {
		return errors.Wrap(err, "failed to open/create file")
	}

	defer fileP.Close()

	bufP := bufio.NewWriter(fileP)
	defer bufP.Flush()

	totalSize := int64(0)
	countLine := 0

	for {
		countLine++

		written, err := bufP.WriteString(fmt.Sprintf("line: %d\n", countLine))
		if err != nil {
			return errors.Wrap(err, "failed to write line")
		}

		totalSize += int64(written)
	}
```

## How to check if file exists

```go
import (
  "os"
  "io/fs"
)

// PathExists returns true if the given path exists. Whether it is a file or a
// directory.
func PathExists(path string) bool {
	_, err := os.Stat(path)

	return err == nil
}

// IsFile returns true if the given path is an existing file.
func IsFile(pathFile string) bool {
	info, err := os.Stat(pathFile)
	if err == nil {
		return !info.IsDir()
	}

	return false
}
```

- [View it online](https://go.dev/play/p/KGvcc3jvX2t) @ GoPlayground

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

## How to deal with/mimic io.Reader

```go
package main

import (
	"errors"
	"fmt"
	"io"
	"strings"
)

func doSomething(rd io.Reader) error {
	if rd == nil {
		return errors.New("nil pointer for input given")
	}

	const bufferSize = 256 // Chunk size to read from rd
	var content []byte     // Read data to store

	// Create buffer to read
	buffer := make([]byte, bufferSize)

	for {
		n, err := rd.Read(buffer)
		if 0 < n {
			// Read
			content = append(content, buffer...)
		}
		if err == io.EOF {
			break // End of file
		}
		if err != nil {
			return err // error
		}
	}

	fmt.Println(string(content))

	return nil
}

func main() {
	// String
	input := "some string"

	r := strings.NewReader(input)

	doSomething(r)
}
```

- [Go Playground](https://go.dev/play/p/6dbW3ygGr7q)

[[Back to top](#)]<!-- ---------------------------------------------- -->

## How to deal with/mimic io.Writer

```go
package main

import (
	"bytes"
	"fmt"
	"io"
)

func writeSomething(w io.Writer) (n int, err error) {
	return w.Write([]byte("foo bar"))
}

func main() {
	var b bytes.Buffer

	writeSomething(&b)

	fmt.Println(b.String())
}
```

- [Go Playground](https://go.dev/play/p/8dnTL0Cfjrx)

## How to deal with/mock/mimic os.Stdin

```go
// mockStdin is a helper function that lets the test pretend dummyInput as os.Stdin.
// It will return a function to `defer` clean up after the test.
//
// Note: This function is not thread-safe. It should not use in parallel tests.
func mockStdin(t *testing.T, dummyInput string) (funcDefer func(), err error) {
	t.Helper()

	oldOsStdin := os.Stdin

	tmpfile, err := os.CreateTemp(t.TempDir(), t.Name())
	if err != nil {
		return nil, errors.Wrap(err, "failed to create temp file during mocking os.Stdin")
	}

	content := []byte(dummyInput)

	if _, err := tmpfile.Write(content); err != nil {
		return nil, errors.Wrap(err, "failed to write to temp file during mocking os.Stdin")
	}

	if _, err := tmpfile.Seek(0, 0); err != nil {
		return nil, errors.Wrap(err, "failed to seek the temp file during mocking os.Stdin")
	}

	// Set stdin to the temp file
	os.Stdin = tmpfile

	return func() {
		// clean up
		os.Stdin = oldOsStdin
		os.Remove(tmpfile.Name())
	}, nil
}
```

- gist: [[Golang] How to mock/mimic os.Stdin during the test in Go](https://gist.github.com/KEINOS/76857bc6339515d7144e00f17adb1090) @ gitst

[[Back to top](#)]<!-- ---------------------------------------------- -->

## How to trim/remove comments

```go
package main

import (
	"fmt"
	"strings"
	"testing"
	"unicode"
)

func StripComment(delimiter, source string) string {
	if strings.Contains(source, "\n") {
		result := []string{}

		lines := strings.Split(source, "\n")
		for _, line := range lines {
			if strings.TrimSpace(line) == "" {
				result = append(result, "")
			}
			stripped := StripComment(delimiter, line)
			if strings.TrimSpace(stripped) != "" {
				result = append(result, stripped)
			}
		}

		return strings.Join(result, "\n")
	}

	if cut := strings.IndexAny(source, delimiter); cut >= 0 {
		return strings.TrimRightFunc(source[:cut], unicode.IsSpace)
	}

	return source
}

func TestStripComment(t *testing.T) {
	for i, test := range []struct {
		input  string
		expect string
	}{
		{input: "# foo bar", expect: ""},
		{input: "foo # bar", expect: "foo"},
		{input: "foo bar # buzz", expect: "foo bar"},
		{input: "foo\n#bar\n#buz\nhoge", expect: "foo\nhoge"},
		{input: "foo\n#bar\n#buz\n\nhoge", expect: "foo\n\nhoge"},
		{input: "foo\n#bar\n#buz\n   \nhoge", expect: "foo\n\nhoge"},
		{input: "foo\n#bar\n#buz\n   hoge\nfuga", expect: "foo\n   hoge\nfuga"},
		{input: "foo\nbar #buz\n   hoge #fuga\npiyo", expect: "foo\nbar\n   hoge\npiyo"},
	} {
		expect := test.expect
		actual := StripComment("#", test.input)

		if expect != actual {
			fmt.Printf("test #%d failed. got: %s, want: %s\n", i+1, actual, expect)
			t.Fail()
		}
	}
}
```

- Virew on [Go Playground](https://go.dev/play/p/8h64FgqWw8v)
- References:
  - [Strip_comments_from_a_string#Go](https://rosettacode.org/wiki/Strip_comments_from_a_string#Go) @ rosettacode.org

[[Back to top](#)]<!-- ---------------------------------------------- -->

## How to shuffle a slice

```go
// https://golang.org/pkg/math/rand/

package main

import (
	"fmt"
	"math/rand"
	"time"
)

func main() {
	cards := []string{"2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"}
	cards4 := []string{}

	// Prepare 4 stacks of cards
	for i := 0; i < 4; i++ {
		cards4 = append(cards4, cards...)
	}

	rand.Seed(time.Now().UnixNano())
	rand.Shuffle(len(cards4), func(i, j int) { cards4[i], cards4[j] = cards4[j], cards4[i] })

	fmt.Println(cards4)
	// [7 3 10 7 10 9 A 8 K 9 J 10 10 A K Q K 5 K Q 6 J 3 8 2 6 2 7 Q J 8 3 J 6 2 8 4 9 A 9 2 4 4 3 5 A 4 6 5 Q 7 5]
	// [5 2 K K K 10 4 J 9 8 A 3 3 5 4 Q 9 3 4 J 7 6 5 Q 10 J A A 2 7 9 6 7 8 8 7 9 K Q 2 J 5 10 2 4 Q 8 A 6 6 10 3]
}
```

- References:
  - [proposal: math/rand: add Shuffle #20480](https://github.com/golang/go/issues/20480) @ GitHub
  - [math/rand: add Shuffle](https://go-review.googlesource.com/c/go/+/51891) | go-review @ googlesource.com
  - [Go 言語でスライス/配列をランダムな順番でシャッフルっする #3026](https://github.com/YumaInaura/YumaInaura/issues/3026) | YumaInaura @ GitHub

[[Back to top](#)]<!-- ---------------------------------------------- -->

## How to remove a repeated spaces in a string

```go
func TrimWordGaps(s string) string {
	return strings.Join(strings.Fields(s), " ")
}
```

- [文字間の複数ホワイトスペースを削除して1つのスペースに置き換える関数](https://qiita.com/KEINOS/items/8b64a3f1b06ddc2d0399) @ Qiita
- [How to remove redundant spaces/whitespace from a string in Golang?](https://stackoverflow.com/a/42251527/18152508) @ StackOverflow

[[Back to top](#)]<!-- ---------------------------------------------- -->

## How to get an element randomly from a slice

```go
rand.Seed(time.Now().UnixNano())
choises := []string{
	"One",
	"Two",
	"Three",
	"Four",
}
fmt.Println("Random pick:", choises[rand.Intn(len(choises))])
```

[[Back to top](#)]<!-- ---------------------------------------------- -->
