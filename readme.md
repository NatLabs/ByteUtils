## ByteUtils

Encoding and decoding Primitive motoko types to bytes. 

> Add important note: 
> ONlY works with moc v0.14.9 and above

### Getting Started

#### Little Endian
Can either use `LittleEndian` or `LE`
```motoko
assert ByteUtils.LittleEndian.fromInt32(-1_234_567_890) == [0xD2, 0x02, 0x96, 0xB6];
assert ByteUtils.LE.toInt32([0xD2, 0x02, 0x96, 0xB6].vals()) == -1_234_567_890;
```

#### Big Endian
Can either use `BigEndian` or `BE`
```motoko
assert ByteUtils.BigEndian.fromNat16(0x1234) == [0x12, 0x34];
assert ByteUtils.BE.toNat16([0x12, 0x34].vals()) == 0x1234;
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
These LEB and SLEB methods, `*LEB128_64()`, can only encode and decode up to `Nat64` and `Int64`

```motoko

assert ByteUtils.toLEB128_64(624485) == [0xe5, 0x8e, 0x26];
assert ByteUtils.fromLEB128_64([0xe5, 0x8e, 0x26]) == 624485;

let buffer = Buffer.Buffer<Nat8>(10);
assert ByteUtils.Buffer.addSLEB128_64(buffer, -12345678);
assert Buffer.toArray(buffer) == [0xb2, 0xbd, 0x8e, 0x7a];

assert ByteUtils.Buffer.readSLEB128_64(buffer, 0) == -12345678;

```