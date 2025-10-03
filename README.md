# Benchmark Results



<details>

<summary>bench/BigEndian.bench.mo $({\color{gray}0\%})$</summary>

### ByteUtils library Benchmarks: Big Endian Conversions

_Benchmarking the performance with 10k calls for type-to-bytes and bytes-to-type conversions_


Instructions: ${\color{gray}0\\%}$
Heap: ${\color{gray}0\\%}$
Stable Memory: ${\color{gray}0\\%}$
Garbage Collection: ${\color{gray}0\\%}$


**Instructions**

|            |                      Type to Bytes |                      Bytes to Type |
| :--------- | ---------------------------------: | ---------------------------------: |
| Nat8       |   3_162_100 $({\color{gray}0\\%})$ |  10_662_249 $({\color{gray}0\\%})$ |
| Nat16      |   4_942_936 $({\color{gray}0\\%})$ |  12_413_084 $({\color{gray}0\\%})$ |
| Nat32      |   5_369_757 $({\color{gray}0\\%})$ |  17_972_462 $({\color{gray}0\\%})$ |
| Nat64      |   5_964_564 $({\color{gray}0\\%})$ |  27_084_710 $({\color{gray}0\\%})$ |
| Int8       |   3_185_076 $({\color{gray}0\\%})$ |  10_665_221 $({\color{gray}0\\%})$ |
| Int16      |   4_945_912 $({\color{gray}0\\%})$ |  12_416_056 $({\color{gray}0\\%})$ |
| Int32      |   6_351_116 $({\color{gray}0\\%})$ |  18_953_379 $({\color{gray}0\\%})$ |
| Int64      |   7_737_540 $({\color{gray}0\\%})$ |  28_837_682 $({\color{gray}0\\%})$ |
| Float      | 312_771_042 $({\color{gray}0\\%})$ | 314_008_216 $({\color{gray}0\\%})$ |
| LEB128_64  |  83_963_054 $({\color{gray}0\\%})$ | 104_734_056 $({\color{gray}0\\%})$ |
| SLEB128_64 | 174_413_695 $({\color{gray}0\\%})$ | 110_880_653 $({\color{gray}0\\%})$ |


**Heap**

|            |                     Type to Bytes |                     Bytes to Type |
| :--------- | --------------------------------: | --------------------------------: |
| Nat8       | 166.09 KiB $({\color{gray}0\\%})$ | 791.09 KiB $({\color{gray}0\\%})$ |
| Nat16      | 400.46 KiB $({\color{gray}0\\%})$ | 791.09 KiB $({\color{gray}0\\%})$ |
| Nat32      | 556.71 KiB $({\color{gray}0\\%})$ | 849.95 KiB $({\color{gray}0\\%})$ |
| Nat64      | 869.21 KiB $({\color{gray}0\\%})$ | 947.34 KiB $({\color{gray}0\\%})$ |
| Int8       | 166.09 KiB $({\color{gray}0\\%})$ | 791.09 KiB $({\color{gray}0\\%})$ |
| Int16      | 400.46 KiB $({\color{gray}0\\%})$ | 791.09 KiB $({\color{gray}0\\%})$ |
| Int32      | 615.68 KiB $({\color{gray}0\\%})$ | 908.77 KiB $({\color{gray}0\\%})$ |
| Int64      |      1 MiB $({\color{gray}0\\%})$ |   1.08 MiB $({\color{gray}0\\%})$ |
| Float      | -13.09 MiB $({\color{gray}0\\%})$ |   8.75 MiB $({\color{gray}0\\%})$ |
| LEB128_64  | -18.01 MiB $({\color{gray}0\\%})$ |   7.03 MiB $({\color{gray}0\\%})$ |
| SLEB128_64 |   11.5 MiB $({\color{gray}0\\%})$ | -19.52 MiB $({\color{gray}0\\%})$ |


**Garbage Collection**

|            |                    Type to Bytes |                    Bytes to Type |
| :--------- | -------------------------------: | -------------------------------: |
| Nat8       |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Nat16      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Nat32      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Nat64      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int8       |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int16      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int32      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int64      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Float      | 26.84 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| LEB128_64  | 24.79 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| SLEB128_64 |       0 B $({\color{gray}0\\%})$ | 26.84 MiB $({\color{gray}0\\%})$ |


</details>
Saving results to .bench/BigEndian.bench.json

<details>

<summary>bench/LittleEndian.bench.mo $({\color{gray}0\%})$</summary>

### ByteUtils library Benchmarks: Little Endian Conversions

_Benchmarking the performance with 10k calls for type-to-bytes and bytes-to-type conversions_


Instructions: ${\color{gray}0\\%}$
Heap: ${\color{gray}0\\%}$
Stable Memory: ${\color{gray}0\\%}$
Garbage Collection: ${\color{gray}0\\%}$


**Instructions**

|            |                      Type to Bytes |                      Bytes to Type |
| :--------- | ---------------------------------: | ---------------------------------: |
| Nat8       |   3_162_100 $({\color{gray}0\\%})$ |  10_662_249 $({\color{gray}0\\%})$ |
| Nat16      |   4_942_936 $({\color{gray}0\\%})$ |  12_413_084 $({\color{gray}0\\%})$ |
| Nat32      |   5_369_757 $({\color{gray}0\\%})$ |  17_972_462 $({\color{gray}0\\%})$ |
| Nat64      |   5_964_564 $({\color{gray}0\\%})$ |  27_084_710 $({\color{gray}0\\%})$ |
| Int8       |   3_185_076 $({\color{gray}0\\%})$ |  10_665_221 $({\color{gray}0\\%})$ |
| Int16      |   4_945_912 $({\color{gray}0\\%})$ |  12_416_056 $({\color{gray}0\\%})$ |
| Int32      |   6_351_116 $({\color{gray}0\\%})$ |  18_953_379 $({\color{gray}0\\%})$ |
| Int64      |   7_737_540 $({\color{gray}0\\%})$ |  28_837_682 $({\color{gray}0\\%})$ |
| Float      | 306_371_042 $({\color{gray}0\\%})$ | 307_608_216 $({\color{gray}0\\%})$ |
| LEB128_64  |  83_963_054 $({\color{gray}0\\%})$ | 104_734_056 $({\color{gray}0\\%})$ |
| SLEB128_64 | 174_413_695 $({\color{gray}0\\%})$ | 110_880_653 $({\color{gray}0\\%})$ |


**Heap**

|            |                     Type to Bytes |                     Bytes to Type |
| :--------- | --------------------------------: | --------------------------------: |
| Nat8       | 166.09 KiB $({\color{gray}0\\%})$ | 791.09 KiB $({\color{gray}0\\%})$ |
| Nat16      | 400.46 KiB $({\color{gray}0\\%})$ | 791.09 KiB $({\color{gray}0\\%})$ |
| Nat32      | 556.71 KiB $({\color{gray}0\\%})$ | 849.95 KiB $({\color{gray}0\\%})$ |
| Nat64      | 869.21 KiB $({\color{gray}0\\%})$ | 947.34 KiB $({\color{gray}0\\%})$ |
| Int8       | 166.09 KiB $({\color{gray}0\\%})$ | 791.09 KiB $({\color{gray}0\\%})$ |
| Int16      | 400.46 KiB $({\color{gray}0\\%})$ | 791.09 KiB $({\color{gray}0\\%})$ |
| Int32      | 615.68 KiB $({\color{gray}0\\%})$ | 908.77 KiB $({\color{gray}0\\%})$ |
| Int64      |      1 MiB $({\color{gray}0\\%})$ |   1.08 MiB $({\color{gray}0\\%})$ |
| Float      | -13.09 MiB $({\color{gray}0\\%})$ |   8.75 MiB $({\color{gray}0\\%})$ |
| LEB128_64  | -18.01 MiB $({\color{gray}0\\%})$ |   7.03 MiB $({\color{gray}0\\%})$ |
| SLEB128_64 |   11.5 MiB $({\color{gray}0\\%})$ | -19.52 MiB $({\color{gray}0\\%})$ |


**Garbage Collection**

|            |                    Type to Bytes |                    Bytes to Type |
| :--------- | -------------------------------: | -------------------------------: |
| Nat8       |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Nat16      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Nat32      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Nat64      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int8       |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int16      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int32      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Int64      |       0 B $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| Float      | 26.84 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| LEB128_64  | 24.79 MiB $({\color{gray}0\\%})$ |       0 B $({\color{gray}0\\%})$ |
| SLEB128_64 |       0 B $({\color{gray}0\\%})$ | 26.84 MiB $({\color{gray}0\\%})$ |


</details>
Saving results to .bench/LittleEndian.bench.json

<details>

<summary>bench/Sorted.bench.mo $({\color{green}-0.00\%})$</summary>

### ByteUtils library Benchmarks: Sorted Encodings

_Benchmarking the performance with 10k calls for type-to-bytes and bytes-to-type conversions using sortable encodings_


Instructions: ${\color{green}-0.00\\%}$
Heap: ${\color{gray}0\\%}$
Stable Memory: ${\color{gray}0\\%}$
Garbage Collection: ${\color{gray}0\\%}$


**Instructions**

|       |                           Type to Bytes |                      Bytes to Type |
| :---- | --------------------------------------: | ---------------------------------: |
| Nat8  |        3_162_088 $({\color{gray}0\\%})$ |  10_592_237 $({\color{gray}0\\%})$ |
| Nat16 |        4_942_924 $({\color{gray}0\\%})$ |  12_353_072 $({\color{gray}0\\%})$ |
| Nat32 |        5_367_788 $({\color{gray}0\\%})$ |  17_892_685 $({\color{gray}0\\%})$ |
| Nat64 |        5_964_552 $({\color{gray}0\\%})$ |  27_014_698 $({\color{gray}0\\%})$ |
| Int8  |        3_205_064 $({\color{gray}0\\%})$ |  10_595_209 $({\color{gray}0\\%})$ |
| Int16 |        4_965_900 $({\color{gray}0\\%})$ |  12_356_044 $({\color{gray}0\\%})$ |
| Int32 |        5_391_676 $({\color{gray}0\\%})$ |  17_988_367 $({\color{gray}0\\%})$ |
| Int64 |        5_987_687 $({\color{gray}0\\%})$ |  27_077_670 $({\color{gray}0\\%})$ |
| Float | 338_873_048 $({\color{green}-0.02\\%})$ | 344_788_230 $({\color{gray}0\\%})$ |


**Heap**

|       |                     Type to Bytes |                     Bytes to Type |
| :---- | --------------------------------: | --------------------------------: |
| Nat8  | 166.09 KiB $({\color{gray}0\\%})$ | 791.09 KiB $({\color{gray}0\\%})$ |
| Nat16 | 400.46 KiB $({\color{gray}0\\%})$ | 791.09 KiB $({\color{gray}0\\%})$ |
| Nat32 | 556.71 KiB $({\color{gray}0\\%})$ | 849.21 KiB $({\color{gray}0\\%})$ |
| Nat64 | 869.21 KiB $({\color{gray}0\\%})$ | 947.34 KiB $({\color{gray}0\\%})$ |
| Int8  | 166.09 KiB $({\color{gray}0\\%})$ | 791.09 KiB $({\color{gray}0\\%})$ |
| Int16 | 400.46 KiB $({\color{gray}0\\%})$ | 791.09 KiB $({\color{gray}0\\%})$ |
| Int32 | 556.71 KiB $({\color{gray}0\\%})$ | 850.17 KiB $({\color{gray}0\\%})$ |
| Int64 |  -27.4 MiB $({\color{gray}0\\%})$ | 947.34 KiB $({\color{gray}0\\%})$ |
| Float |  15.88 MiB $({\color{gray}0\\%})$ | -16.05 MiB $({\color{gray}0\\%})$ |


**Garbage Collection**

|       |                    Type to Bytes |                   Bytes to Type |
| :---- | -------------------------------: | ------------------------------: |
| Nat8  |       0 B $({\color{gray}0\\%})$ |      0 B $({\color{gray}0\\%})$ |
| Nat16 |       0 B $({\color{gray}0\\%})$ |      0 B $({\color{gray}0\\%})$ |
| Nat32 |       0 B $({\color{gray}0\\%})$ |      0 B $({\color{gray}0\\%})$ |
| Nat64 |       0 B $({\color{gray}0\\%})$ |      0 B $({\color{gray}0\\%})$ |
| Int8  |       0 B $({\color{gray}0\\%})$ |      0 B $({\color{gray}0\\%})$ |
| Int16 |       0 B $({\color{gray}0\\%})$ |      0 B $({\color{gray}0\\%})$ |
| Int32 |       0 B $({\color{gray}0\\%})$ |      0 B $({\color{gray}0\\%})$ |
| Int64 | 28.25 MiB $({\color{gray}0\\%})$ |      0 B $({\color{gray}0\\%})$ |
| Float |       0 B $({\color{gray}0\\%})$ | 26.2 MiB $({\color{gray}0\\%})$ |


</details>
Saving results to .bench/Sorted.bench.json
