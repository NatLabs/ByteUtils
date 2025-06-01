## ByteUtils

A comprehensive motoko library that provides high performance conversion utilities for byte-level serialization and deserialization of motoko number types.

> NOTE: This library requires `moc` v0.14.9 or higher.

### Key Features

- **Supported types**: `Nat8/16/32/64`, `Int8/16/32/64`, and `Float`.
- **Order-Preserving Serialization**: Specialized `Sorted` module that maintains the sorted order of the number type when encoded, ensuring that the serialized output is consistent with the natural ordering of the input values.
- **Variable-Length Encoding**: Efficient LEB128 and SLEB128 encoding for space-optimized integer storage (currently only supports 64-bit values)
- **Buffer Integration**: Direct buffer operations with offset-based read and write operations for incremental processing
- Full Support for Little Endian and Big Endian conversion modules


### Getting Started

#### Installation
```bash
mops add byte-utils
```

#### Little Endian
Can use `LittleEndian` or `LE`
```motoko
assert ByteUtils.LittleEndian.fromInt32(-1_234_567_890) == [0xD2, 0x02, 0x96, 0xB6];
assert ByteUtils.LE.toInt32([0xD2, 0x02, 0x96, 0xB6].vals()) == -1_234_567_890;
```

#### Big Endian
Can use `BigEndian` or `BE`
```motoko
assert ByteUtils.BigEndian.fromNat16(0x1234) == [0x12, 0x34];
assert ByteUtils.BE.toNat16([0x12, 0x34].vals()) == 0x1234;
```

#### Sorted 

```motoko
let n1 = ByteUtils.Sorted.fromNat16(0x1234);
let n2 = ByteUtils.Sorted.fromNat16(0x5678);

assert 0x1234 < 0x5678;
assert n1 < n2;
```

#### Buffer
```motoko
import ByteUtils "mo:byte-utils";

let buffer = Buffer.Buffer<Nat8>(10);
ByteUtils.Buffer.LE.addInt32(buffer, -1_234_567_890);
assert Buffer.toArray(buffer) == [0xD2, 0x02, 0x96, 0xB6];

assert ByteUtils.Buffer.LE.readInt32(buffer, 0) == -1_234_567_890;

```

#### LEB128/SLEB128

```motoko

assert ByteUtils.toLEB128_64(624485) == [0xe5, 0x8e, 0x26];
assert ByteUtils.fromLEB128_64([0xe5, 0x8e, 0x26]) == 624485;

let buffer = Buffer.Buffer<Nat8>(10);
assert ByteUtils.Buffer.addSLEB128_64(buffer, -12345678);
assert Buffer.toArray(buffer) == [0xb2, 0xbd, 0x8e, 0x7a];

assert ByteUtils.Buffer.readSLEB128_64(buffer, 0) == -12345678;

```