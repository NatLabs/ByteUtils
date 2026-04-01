# Benchmark Results



<details>

<summary>bench/BigEndian.bench.mo $({\color{red}+10.21\%})$</summary>

### ByteUtils library Benchmarks: Big Endian Conversions

_Benchmarking the performance with 10k calls for type-to-bytes and bytes-to-type conversions_


Instructions: ${\color{red}+10.20\\%}$
Heap: ${\color{gray}0\\%}$
Stable Memory: ${\color{gray}0\\%}$
Garbage Collection: ${\color{red}+0.01\\%}$


**Instructions**

|            |                         Type to Bytes |                         Bytes to Type |
| :--------- | ------------------------------------: | ------------------------------------: |
| Nat8       |  2_035_851 $({\color{red}+19.67\\%})$ |  5_696_302 $({\color{red}+13.89\\%})$ |
| Nat16      |  2_426_732 $({\color{red}+16.00\\%})$ |  7_397_059 $({\color{red}+10.36\\%})$ |
| Nat32      |  3_000_429 $({\color{red}+20.80\\%})$ |  12_168_413 $({\color{red}+6.06\\%})$ |
| Nat64      |  3_738_860 $({\color{red}+22.82\\%})$ |  20_398_693 $({\color{red}+3.53\\%})$ |
| Int8       |  2_078_474 $({\color{red}+19.19\\%})$ |  5_698_921 $({\color{red}+13.88\\%})$ |
| Int16      |  2_429_355 $({\color{red}+15.97\\%})$ |  7_399_678 $({\color{red}+10.36\\%})$ |
| Int32      |  3_284_239 $({\color{red}+18.53\\%})$ |  12_446_322 $({\color{red}+5.91\\%})$ |
| Int64      |  4_131_524 $({\color{red}+20.21\\%})$ |  20_771_394 $({\color{red}+3.46\\%})$ |
| Float      | 306_155_630 $({\color{red}+0.41\\%})$ | 256_233_982 $({\color{red}+0.27\\%})$ |
| LEB128_64  | 151_507_702 $({\color{red}+0.89\\%})$ | 166_562_160 $({\color{red}+0.81\\%})$ |
| SLEB128_64 | 222_340_836 $({\color{red}+0.61\\%})$ | 171_332_191 $({\color{red}+0.79\\%})$ |


**Heap**

|            |                Type to Bytes |                Bytes to Type |
| :--------- | ---------------------------: | ---------------------------: |
| Nat8       | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Nat16      | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Nat32      | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Nat64      | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Int8       | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Int16      | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Int32      | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Int64      | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Float      | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| LEB128_64  | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| SLEB128_64 | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |


**Garbage Collection**

|            |                        Type to Bytes |                        Bytes to Type |
| :--------- | -----------------------------------: | -----------------------------------: |
| Nat8       | 133.62 KiB $({\color{red}+0.03\\%})$ | 641.43 KiB $({\color{red}+0.01\\%})$ |
| Nat16      | 328.93 KiB $({\color{red}+0.01\\%})$ | 641.43 KiB $({\color{red}+0.01\\%})$ |
| Nat32      | 485.18 KiB $({\color{red}+0.01\\%})$ | 680.68 KiB $({\color{red}+0.01\\%})$ |
| Nat64      | 797.68 KiB $({\color{red}+0.00\\%})$ | 758.62 KiB $({\color{red}+0.00\\%})$ |
| Int8       | 133.62 KiB $({\color{red}+0.03\\%})$ | 641.43 KiB $({\color{red}+0.01\\%})$ |
| Int16      | 328.93 KiB $({\color{red}+0.01\\%})$ | 641.43 KiB $({\color{red}+0.01\\%})$ |
| Int32      |  524.5 KiB $({\color{red}+0.01\\%})$ | 719.89 KiB $({\color{red}+0.00\\%})$ |
| Int64      | 914.87 KiB $({\color{red}+0.00\\%})$ | 875.81 KiB $({\color{red}+0.00\\%})$ |
| Float      |  10.58 MiB $({\color{red}+0.00\\%})$ |   7.49 MiB $({\color{red}+0.00\\%})$ |
| LEB128_64  |   5.41 MiB $({\color{red}+0.00\\%})$ |   5.01 MiB $({\color{red}+0.00\\%})$ |
| SLEB128_64 |   9.66 MiB $({\color{red}+0.00\\%})$ |   5.27 MiB $({\color{red}+0.00\\%})$ |


</details>
Saving results to .bench/BigEndian.bench.json

<details>

<summary>bench/LittleEndian.bench.mo $({\color{red}+10.21\%})$</summary>

### ByteUtils library Benchmarks: Little Endian Conversions

_Benchmarking the performance with 10k calls for type-to-bytes and bytes-to-type conversions_


Instructions: ${\color{red}+10.20\\%}$
Heap: ${\color{gray}0\\%}$
Stable Memory: ${\color{gray}0\\%}$
Garbage Collection: ${\color{red}+0.01\\%}$


**Instructions**

|            |                         Type to Bytes |                         Bytes to Type |
| :--------- | ------------------------------------: | ------------------------------------: |
| Nat8       |  2_035_851 $({\color{red}+19.67\\%})$ |  5_696_302 $({\color{red}+13.89\\%})$ |
| Nat16      |  2_426_732 $({\color{red}+16.00\\%})$ |  7_397_059 $({\color{red}+10.36\\%})$ |
| Nat32      |  3_000_429 $({\color{red}+20.80\\%})$ |  12_168_413 $({\color{red}+6.06\\%})$ |
| Nat64      |  3_738_860 $({\color{red}+22.82\\%})$ |  20_398_693 $({\color{red}+3.53\\%})$ |
| Int8       |  2_078_474 $({\color{red}+19.19\\%})$ |  5_698_921 $({\color{red}+13.88\\%})$ |
| Int16      |  2_429_355 $({\color{red}+15.97\\%})$ |  7_399_678 $({\color{red}+10.36\\%})$ |
| Int32      |  3_284_239 $({\color{red}+18.53\\%})$ |  12_446_322 $({\color{red}+5.91\\%})$ |
| Int64      |  4_131_524 $({\color{red}+20.21\\%})$ |  20_771_394 $({\color{red}+3.46\\%})$ |
| Float      | 299_755_630 $({\color{red}+0.42\\%})$ | 249_833_982 $({\color{red}+0.28\\%})$ |
| LEB128_64  | 151_507_702 $({\color{red}+0.89\\%})$ | 166_562_160 $({\color{red}+0.81\\%})$ |
| SLEB128_64 | 222_340_836 $({\color{red}+0.61\\%})$ | 171_332_191 $({\color{red}+0.79\\%})$ |


**Heap**

|            |                Type to Bytes |                Bytes to Type |
| :--------- | ---------------------------: | ---------------------------: |
| Nat8       | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Nat16      | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Nat32      | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Nat64      | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Int8       | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Int16      | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Int32      | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Int64      | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Float      | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| LEB128_64  | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| SLEB128_64 | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |


**Garbage Collection**

|            |                        Type to Bytes |                        Bytes to Type |
| :--------- | -----------------------------------: | -----------------------------------: |
| Nat8       | 133.62 KiB $({\color{red}+0.03\\%})$ | 641.43 KiB $({\color{red}+0.01\\%})$ |
| Nat16      | 328.93 KiB $({\color{red}+0.01\\%})$ | 641.43 KiB $({\color{red}+0.01\\%})$ |
| Nat32      | 485.18 KiB $({\color{red}+0.01\\%})$ | 680.68 KiB $({\color{red}+0.01\\%})$ |
| Nat64      | 797.68 KiB $({\color{red}+0.00\\%})$ | 758.62 KiB $({\color{red}+0.00\\%})$ |
| Int8       | 133.62 KiB $({\color{red}+0.03\\%})$ | 641.43 KiB $({\color{red}+0.01\\%})$ |
| Int16      | 328.93 KiB $({\color{red}+0.01\\%})$ | 641.43 KiB $({\color{red}+0.01\\%})$ |
| Int32      |  524.5 KiB $({\color{red}+0.01\\%})$ | 719.89 KiB $({\color{red}+0.00\\%})$ |
| Int64      | 914.87 KiB $({\color{red}+0.00\\%})$ | 875.81 KiB $({\color{red}+0.00\\%})$ |
| Float      |  10.58 MiB $({\color{red}+0.00\\%})$ |   7.49 MiB $({\color{red}+0.00\\%})$ |
| LEB128_64  |   5.41 MiB $({\color{red}+0.00\\%})$ |   5.01 MiB $({\color{red}+0.00\\%})$ |
| SLEB128_64 |   9.66 MiB $({\color{red}+0.00\\%})$ |   5.27 MiB $({\color{red}+0.00\\%})$ |


</details>
Saving results to .bench/LittleEndian.bench.json

<details>

<summary>bench/Sorted.bench.mo $({\color{red}+12.56\%})$</summary>

### ByteUtils library Benchmarks: Sorted Encodings

_Benchmarking the performance with 10k calls for type-to-bytes and bytes-to-type conversions using sortable encodings_


Instructions: ${\color{red}+12.56\\%}$
Heap: ${\color{gray}0\\%}$
Stable Memory: ${\color{gray}0\\%}$
Garbage Collection: ${\color{red}+0.01\\%}$


**Instructions**

|       |                         Type to Bytes |                         Bytes to Type |
| :---- | ------------------------------------: | ------------------------------------: |
| Nat8  |  2_035_839 $({\color{red}+19.66\\%})$ |  5_626_700 $({\color{red}+14.09\\%})$ |
| Nat16 |  2_426_720 $({\color{red}+15.99\\%})$ |  7_337_047 $({\color{red}+10.45\\%})$ |
| Nat32 |  2_995_020 $({\color{red}+20.65\\%})$ |  12_097_267 $({\color{red}+6.09\\%})$ |
| Nat64 |  3_738_766 $({\color{red}+22.82\\%})$ |  20_328_640 $({\color{red}+3.54\\%})$ |
| Int8  |  2_098_503 $({\color{red}+18.97\\%})$ |  5_628_950 $({\color{red}+14.08\\%})$ |
| Int16 |  2_449_384 $({\color{red}+15.82\\%})$ |  7_339_707 $({\color{red}+10.45\\%})$ |
| Int32 |  3_020_262 $({\color{red}+20.53\\%})$ |  12_171_280 $({\color{red}+6.05\\%})$ |
| Int64 |  3_761_430 $({\color{red}+22.65\\%})$ |  20_391_382 $({\color{red}+3.53\\%})$ |
| Float | 314_813_782 $({\color{red}+0.40\\%})$ | 278_194_365 $({\color{red}+0.25\\%})$ |


**Heap**

|       |                Type to Bytes |                Bytes to Type |
| :---- | ---------------------------: | ---------------------------: |
| Nat8  | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Nat16 | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Nat32 | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Nat64 | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Int8  | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Int16 | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Int32 | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Int64 | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |
| Float | 272 B $({\color{gray}0\\%})$ | 272 B $({\color{gray}0\\%})$ |


**Garbage Collection**

|       |                        Type to Bytes |                        Bytes to Type |
| :---- | -----------------------------------: | -----------------------------------: |
| Nat8  | 133.62 KiB $({\color{red}+0.03\\%})$ | 641.43 KiB $({\color{red}+0.01\\%})$ |
| Nat16 | 328.93 KiB $({\color{red}+0.01\\%})$ | 641.43 KiB $({\color{red}+0.01\\%})$ |
| Nat32 | 485.18 KiB $({\color{red}+0.01\\%})$ | 680.18 KiB $({\color{red}+0.01\\%})$ |
| Nat64 | 797.68 KiB $({\color{red}+0.00\\%})$ | 758.62 KiB $({\color{red}+0.00\\%})$ |
| Int8  | 133.62 KiB $({\color{red}+0.03\\%})$ | 641.43 KiB $({\color{red}+0.01\\%})$ |
| Int16 | 328.93 KiB $({\color{red}+0.01\\%})$ | 641.43 KiB $({\color{red}+0.01\\%})$ |
| Int32 | 485.18 KiB $({\color{red}+0.01\\%})$ | 680.82 KiB $({\color{red}+0.01\\%})$ |
| Int64 | 797.68 KiB $({\color{red}+0.00\\%})$ | 758.62 KiB $({\color{red}+0.00\\%})$ |
| Float |  11.12 MiB $({\color{red}+0.00\\%})$ |   8.68 MiB $({\color{red}+0.00\\%})$ |


</details>
Saving results to .bench/Sorted.bench.json
