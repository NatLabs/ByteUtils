## First Implementation

ByteUtils library Benchmarks: Conversion from number to bytes

Benchmarking the performance with 10k calls


Instructions

|              | fromNat8() | fromNat16() | fromNat32() | fromNat64() | fromFloat() |
| :----------- | ---------: | ----------: | ----------: | ----------: | ----------: |
| LittleEndian |  1_702_135 |   2_272_987 |   3_538_621 |   5_445_027 | 238_308_012 |
| BigEndian    |  1_701_337 |   2_272_111 |   3_537_667 |   5_443_995 | 244_786_902 |


Heap

|              | fromNat8() | fromNat16() | fromNat32() | fromNat64() | fromFloat() |
| :----------- | ---------: | ----------: | ----------: | ----------: | ----------: |
| LittleEndian |      272 B |       272 B |       272 B |       272 B |       272 B |
| BigEndian    |      272 B |       272 B |       272 B |       272 B |       272 B |


Garbage Collection

|              | fromNat8() | fromNat16() | fromNat32() | fromNat64() | fromFloat() |
| :----------- | ---------: | ----------: | ----------: | ----------: | ----------: |
| LittleEndian | 117.57 KiB |  156.63 KiB |  234.76 KiB |  391.01 KiB |   11.41 MiB |
| BigEndian    | 117.57 KiB |  156.63 KiB |  234.76 KiB |  391.01 KiB |   11.41 MiB |


## Using Prim.explode()

ByteUtils library Benchmarks: Conversion from number to bytes

Benchmarking the performance with 10k calls


Instructions

|              | fromNat8() | fromNat16() | fromNat32() | fromNat64() | fromFloat() |
| :----------- | ---------: | ----------: | ----------: | ----------: | ----------: |
| LittleEndian |  1_702_135 |   2_233_113 |   2_644_083 |   3_265_594 | 238_307_539 |
| BigEndian    |  1_701_337 |   2_232_237 |   2_643_129 |   3_264_562 | 244_786_429 |


Heap

|              | fromNat8() | fromNat16() | fromNat32() | fromNat64() | fromFloat() |
| :----------- | ---------: | ----------: | ----------: | ----------: | ----------: |
| LittleEndian |      272 B |       272 B |       272 B |       272 B |       272 B |
| BigEndian    |      272 B |       272 B |       272 B |       272 B |       272 B |


Garbage Collection

|              | fromNat8() | fromNat16() | fromNat32() | fromNat64() | fromFloat() |
| :----------- | ---------: | ----------: | ----------: | ----------: | ----------: |
| LittleEndian | 117.57 KiB |  312.88 KiB |  469.13 KiB |  781.63 KiB |   11.41 MiB |
| BigEndian    | 117.57 KiB |  312.88 KiB |  469.13 KiB |  781.63 KiB |   11.41 MiB |