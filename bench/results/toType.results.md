## Initial Implementation

ByteUtils library Benchmarks: Conversion from bytes to number

Benchmarking the performance with 10k calls


Instructions

|              |  toNat8() | toNat16() |  toNat32() |  toNat64() |   toFloat() |
| :----------- | --------: | --------: | ---------: | ---------: | ----------: |
| LittleEndian | 3_532_396 | 5_603_133 | 10_079_741 | 18_394_817 | 270_778_734 |
| BigEndian    | 3_531_598 | 5_602_257 | 10_078_787 | 18_393_785 | 277_257_624 |


Heap

|              | toNat8() | toNat16() | toNat32() | toNat64() | toFloat() |
| :----------- | -------: | --------: | --------: | --------: | --------: |
| LittleEndian |    272 B |     272 B |     272 B |     272 B |     272 B |
| BigEndian    |    272 B |     272 B |     272 B |     272 B |     272 B |


Garbage Collection

|              |   toNat8() |  toNat16() |  toNat32() |  toNat64() | toFloat() |
| :----------- | ---------: | ---------: | ---------: | ---------: | --------: |
| LittleEndian | 625.34 KiB | 625.34 KiB | 664.69 KiB | 742.52 KiB |  7.48 MiB |
| BigEndian    | 625.34 KiB | 625.34 KiB | 664.69 KiB | 742.52 KiB |  7.48 MiB |
