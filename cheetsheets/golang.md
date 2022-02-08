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
