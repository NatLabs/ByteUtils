import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Int8 "mo:base/Int8";
import Int16 "mo:base/Int16";
import Int32 "mo:base/Int32";
import Int64 "mo:base/Int64";
import Float "mo:base/Float";
import { test; suite } "mo:test";

import ByteUtils "../src";
import Fuzz "mo:fuzz";

func xorshift128plus(seed : Nat) : { next() : Nat } {
    var state0 : Nat64 = Nat64.fromNat(seed);
    var state1 : Nat64 = Nat64.fromNat(seed + 1);
    if (state0 == 0) state0 := 1;
    if (state1 == 0) state1 := 2;

    {
        next = func() : Nat {
            var s1 = state0;
            let s0 = state1;
            state0 := s0;
            s1 ^= s1 << 23 : Nat64;
            state1 := s1 ^ s0 ^ (s1 >> 18 : Nat64) ^ (s0 >> 5 : Nat64);
            Nat64.toNat(state1 +% s0); // Use wrapping addition
        };
    };
};

let fuzz = Fuzz.create(xorshift128plus(0xdeadbeef));
let limit = 10_000;

let input = Buffer.Buffer<Nat>(limit);

for (i in Iter.range(0, limit - 1)) {
    input.add(fuzz.nat.randomRange(0, 2 ** 64 - 1));
};

func round_trip_test_on_random_values<A>(
    from : A -> [Nat8],
    to : Iter.Iter<Nat8> -> A,
    transform : (Nat) -> A,
    is_equal : (A, A) -> Bool,
    to_text : A -> Text,
) {
    for (i in Iter.range(0, limit - 1)) {
        let original = transform(input.get(i));
        let bytes = from(original);
        let restored = to(bytes.vals());

        if (not is_equal(restored, original)) {
            Debug.print(debug_show ({ original = to_text(original); restored = to_text(restored); bytes }));
            assert false;
        };
    };
};

func round_trip_endian(
    Fns : ByteUtils.Functions
) {
    test(
        "Nat",
        func() {
            for (i in Iter.range(0, 255)) {
                let original : Nat8 = Nat8.fromNat(i);
                let bytes = Fns.fromNat8(original);
                let restored = Fns.toNat8(bytes.vals());
                assert restored == original;
            };

        },
    );

    test(
        "Nat16",
        func() {
            round_trip_test_on_random_values(
                Fns.fromNat16,
                Fns.toNat16,
                func(n : Nat) : Nat16 = Nat16.fromNat(n % 65_536),
                Nat16.equal,
                Nat16.toText,
            );
        },
    );

    test(
        "Nat32",
        func() {
            round_trip_test_on_random_values(
                Fns.fromNat32,
                Fns.toNat32,
                func(n : Nat) : Nat32 = Nat32.fromNat(n % 4_294_967_296),
                Nat32.equal,
                Nat32.toText,
            );
        },
    );

    test(
        "Nat64",
        func() {
            round_trip_test_on_random_values(
                Fns.fromNat64,
                Fns.toNat64,
                func(n : Nat) : Nat64 = Nat64.fromNat(n),
                Nat64.equal,
                Nat64.toText,
            );
        },
    );

    test(
        "Int8",
        func() {
            for (i in Iter.range(0, 255)) {
                let original : Int8 = Int8.fromInt(i - 128);
                let bytes = Fns.fromInt8(original);
                let restored = Fns.toInt8(bytes.vals());
                assert restored == original;
            };
        },
    );

    test(
        "Int16",
        func() {
            round_trip_test_on_random_values(
                Fns.fromInt16,
                Fns.toInt16,
                func(n : Nat) : Int16 = Int16.fromNat16(Nat16.fromNat(n % 65_536)),
                Int16.equal,
                Int16.toText,
            );
        },
    );

    test(
        "Int32",
        func() {
            round_trip_test_on_random_values(
                Fns.fromInt32,
                Fns.toInt32,
                func(n : Nat) : Int32 = Int32.fromNat32(Nat32.fromNat(n % 4_294_967_296)),
                Int32.equal,
                Int32.toText,
            );
        },
    );

    test(
        "Int64",
        func() {
            round_trip_test_on_random_values(
                Fns.fromInt64,
                Fns.toInt64,
                func(n : Nat) : Int64 = Int64.fromNat64(Nat64.fromNat(n)),
                Int64.equal,
                Int64.toText,
            );
        },
    );

    test(
        "Float",
        func() {
            round_trip_test_on_random_values(
                Fns.fromFloat,
                Fns.toFloat,
                Float.fromInt,
                func(a : Float, b : Float) : Bool {
                    // For floating-point values, we need to account for small precision differences
                    let epsilon : Float = 0.0000001;
                    Float.equalWithin(a, b, epsilon);
                },
                Float.toText,
            );
        },
    )

};

suite(
    "ByteUtils Little-Endian Round-Trip Conversions",
    func() { round_trip_endian(ByteUtils.LittleEndian) },
);

suite(
    "ByteUtils Big-Endian Round-Trip Conversions",
    func() { round_trip_endian(ByteUtils.BigEndian) },
);

suite(
    "ByteUtils Sorted bytes Round-Trip Conversions",
    func() { round_trip_endian(ByteUtils.Sorted) },
);

suite(
    "LEB128/SLEB128 Encoding and Decoding",
    func() {
        test(
            "toLEB128_64/fromLEB128_64 large range testing with fuzzing",
            func() {

                // Test 10,000 random Nat64 values
                for (i in Iter.range(0, 9_999)) {
                    let original : Nat64 = Nat64.fromNat(input.get(i));
                    let encoded = ByteUtils.toLEB128_64(original);
                    let decoded = ByteUtils.fromLEB128_64(encoded.vals());
                    assert decoded == original;
                };
            },
        );

        test(
            "toSLEB128_64/fromSLEB128_64 large range testing with fuzzing",
            func() {

                // Test 10,000 random Int64 values
                for (i in Iter.range(0, 9_999)) {
                    let original : Int64 = Int64.fromNat64(Nat64.fromNat(input.get(i)));
                    let encoded = ByteUtils.toSLEB128_64(original);
                    let decoded = ByteUtils.fromSLEB128_64(encoded.vals());
                    assert decoded == original;
                };
            },
        );

        test(
            "LEB128 test vectors",
            func() {
                // Test vector: (value, expected bytes)
                let testVectors : [(Nat64, [Nat8])] = [
                    (0, [0x00]),
                    (1, [0x01]),
                    (127, [0x7f]),
                    (128, [0x80, 0x01]),
                    (129, [0x81, 0x01]),
                    (255, [0xff, 0x01]),
                    (256, [0x80, 0x02]),
                    (624485, [0xe5, 0x8e, 0x26]),
                    (12345, [0xb9, 0x60]),
                    (123456, [0xc0, 0xc4, 0x07]),
                    (1234567, [0x87, 0xad, 0x4b]),
                    (12345678, [0xce, 0xc2, 0xf1, 0x05]),
                    (123456789, [0x95, 0x9a, 0xef, 0x3a]),
                    (4294967295, [0xff, 0xff, 0xff, 0xff, 0x0f]),
                    (4294967296, [0x80, 0x80, 0x80, 0x80, 0x10]),
                ];

                for ((value, expectedBytes) in testVectors.vals()) {
                    let encoded = ByteUtils.toLEB128_64(value);
                    assert encoded == expectedBytes;

                    let decoded = ByteUtils.fromLEB128_64(encoded.vals());
                    assert decoded == value;

                    let encodedNat = ByteUtils.toLEB128(Nat64.toNat(value));
                    assert encodedNat == expectedBytes;

                    let decodedNat = ByteUtils.fromLEB128(encoded.vals());
                    assert decodedNat == Nat64.toNat(value);
                };
            },
        );

        test(
            "LEB128 large values",
            func() {
                let testVectors : [(Nat, [Nat8])] = [
                    (2 ** 64, [0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x02]),
                    (2 ** 65, [0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x04]),
                    (2 ** 70, [0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x01]),
                    (2 ** 64 + 1, [0x81, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x02]),
                    (123456789012345678901234567890, [0xd2, 0x95, 0xfc, 0xf1, 0xe4, 0x9d, 0xf8, 0xb9, 0xc3, 0xed, 0xbf, 0xc8, 0xee, 0x31]),
                ];

                for ((value, expectedBytes) in testVectors.vals()) {
                    let encoded = ByteUtils.toLEB128(value);
                    Debug.print(debug_show ("leb128 large", value, encoded, expectedBytes));
                    assert encoded == expectedBytes;

                    let decodedNat = ByteUtils.fromLEB128(encoded.vals());
                    assert decodedNat == value;
                };
            },
        );

        test(
            "SLEB128 test vectors ",
            func() {
                // Test vector: (value, expected bytes)
                let testVectors : [(Int64, [Nat8])] = [
                    (0, [0x00]),
                    (1, [0x01]),
                    (-1, [0x7f]),
                    (63, [0x3f]),
                    (-64, [0x40]),
                    (64, [0xc0, 0x00]),
                    (-65, [0xbf, 0x7f]),
                    (127, [0xff, 0x00]),
                    (-128, [0x80, 0x7f]),
                    (128, [0x80, 0x01]),
                    (-129, [0xff, 0x7e]),
                    (12345, [0xb9, 0xe0, 0x00]),
                    (-12345, [0xc7, 0x9f, 0x7f]),
                    (123456, [0xc0, 0xc4, 0x07]),
                    (-123456, [0xc0, 0xbb, 0x78]),
                    (1234567, [0x87, 0xad, 0xcb, 0x00]),
                    (-1234567, [0xf9, 0xd2, 0xb4, 0x7f]),
                    (12345678, [0xce, 0xc2, 0xf1, 0x05]),
                    (-12345678, [0xb2, 0xbd, 0x8e, 0x7a]),
                    (2147483647, [0xff, 0xff, 0xff, 0xff, 0x07]),
                    (-2147483648, [0x80, 0x80, 0x80, 0x80, 0x78]),
                ];

                for ((value, expectedBytes) in testVectors.vals()) {
                    let encoded = ByteUtils.toSLEB128_64(value);
                    assert encoded == expectedBytes;

                    let decoded = ByteUtils.fromSLEB128_64(encoded.vals());
                    assert decoded == value;

                    let encodedInt = ByteUtils.toSLEB128(Int64.toInt(value));
                    assert encodedInt == expectedBytes;

                    let decodedInt = ByteUtils.fromSLEB128(encoded.vals());
                    assert decodedInt == Int64.toInt(value);
                };
            },
        );

        test(
            "SLEB128 large values",
            func() {
                let testVectors : [(Int, [Nat8])] = [
                    (2 ** 64, [0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x02]),
                    (2 ** 65, [0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x04]),
                    (2 ** 70, [0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x01]),
                    (2 ** 64 + 1, [0x81, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x02]),
                    (123456789012345678901234567890, [0xd2, 0x95, 0xfc, 0xf1, 0xe4, 0x9d, 0xf8, 0xb9, 0xc3, 0xed, 0xbf, 0xc8, 0xee, 0x31]),
                    (-1 * (2 ** 64), [0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x7e]),
                    (-1 * (2 ** 65), [0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x7c]),
                    (-1 * (2 ** 70), [0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x7f]),
                    (-1 * (2 ** 64 + 1), [0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x7d]),
                    (-123456789012345678901234567890, [0xae, 0xea, 0x83, 0x8e, 0x9b, 0xe2, 0x87, 0xc6, 0xbc, 0x92, 0xc0, 0xb7, 0x91, 0x4e]),
                ];

                for ((value, expectedBytes) in testVectors.vals()) {
                    let encoded = ByteUtils.toSLEB128(value);
                    Debug.print(debug_show ("sleb128 large", value, encoded, expectedBytes));
                    assert encoded == expectedBytes;

                    let decodedNat = ByteUtils.fromSLEB128(encoded.vals());
                    assert decodedNat == value;
                };
            },
        );

    },
);

suite(
    "Buffer Operations - Little Endian",
    func() {
        test(
            "addNat8/readNat8",
            func() {
                let buf = Buffer.Buffer<Nat8>(10);
                let value : Nat8 = 123;
                ByteUtils.Buffer.LE.addNat8(buf, value);
                let restored = ByteUtils.Buffer.LE.readNat8(buf, 0);
                assert restored == value;
            },
        );

        test(
            "addNat16/readNat16",
            func() {
                let buf = Buffer.Buffer<Nat8>(10);
                let value : Nat16 = 12345;
                ByteUtils.Buffer.LE.addNat16(buf, value);
                let restored = ByteUtils.Buffer.LE.readNat16(buf, 0);
                assert restored == value;
            },
        );

        test(
            "addNat32/readNat32",
            func() {
                let buf = Buffer.Buffer<Nat8>(10);
                let value : Nat32 = 1234567890;
                ByteUtils.Buffer.LE.addNat32(buf, value);
                let restored = ByteUtils.Buffer.LE.readNat32(buf, 0);
                assert restored == value;
            },
        );

        test(
            "addNat64/readNat64",
            func() {
                let buf = Buffer.Buffer<Nat8>(10);
                let value : Nat64 = 1234567890123456789;
                ByteUtils.Buffer.LE.addNat64(buf, value);
                let restored = ByteUtils.Buffer.LE.readNat64(buf, 0);
                assert restored == value;
            },
        );

        test(
            "addInt8/readInt8",
            func() {
                let buf = Buffer.Buffer<Nat8>(10);
                let value : Int8 = -42;
                ByteUtils.Buffer.LE.addInt8(buf, value);
                let restored = ByteUtils.Buffer.LE.readInt8(buf, 0);
                assert restored == value;
            },
        );

        test(
            "addInt16/readInt16",
            func() {
                let buf = Buffer.Buffer<Nat8>(10);
                let value : Int16 = -12345;
                ByteUtils.Buffer.LE.addInt16(buf, value);
                let restored = ByteUtils.Buffer.LE.readInt16(buf, 0);
                assert restored == value;
            },
        );

        test(
            "addInt32/readInt32",
            func() {
                let buf = Buffer.Buffer<Nat8>(10);
                let value : Int32 = -1234567890;
                ByteUtils.Buffer.LE.addInt32(buf, value);
                let restored = ByteUtils.Buffer.LE.readInt32(buf, 0);
                assert restored == value;
            },
        );

        test(
            "addInt64/readInt64",
            func() {
                let buf = Buffer.Buffer<Nat8>(10);
                let value : Int64 = -1234567890123456789;
                ByteUtils.Buffer.LE.addInt64(buf, value);
                let restored = ByteUtils.Buffer.LE.readInt64(buf, 0);
                assert restored == value;
            },
        );

        test(
            "writeNat8/readNat8",
            func() {
                let buf = Buffer.Buffer<Nat8>(10);
                // Fill buffer with zeros
                for (_ in Iter.range(0, 9)) {
                    buf.add(0);
                };

                let value : Nat8 = 123;
                ByteUtils.Buffer.LE.writeNat8(buf, 5, value);
                let restored = ByteUtils.Buffer.LE.readNat8(buf, 5);
                assert restored == value;
            },
        );

        test(
            "writeNat16/readNat16",
            func() {
                let buf = Buffer.Buffer<Nat8>(10);
                // Fill buffer with zeros
                for (_ in Iter.range(0, 9)) {
                    buf.add(0);
                };

                let value : Nat16 = 12345;
                ByteUtils.Buffer.LE.writeNat16(buf, 5, value);
                let restored = ByteUtils.Buffer.LE.readNat16(buf, 5);
                assert restored == value;
            },
        );

        test(
            "Multiple values in buffer",
            func() {
                let buf = Buffer.Buffer<Nat8>(20);

                let nat8val : Nat8 = 123;
                let nat16val : Nat16 = 12345;
                let int8val : Int8 = -42;
                let int16val : Int16 = -12345;

                // Add values to buffer
                ByteUtils.Buffer.LE.addNat8(buf, nat8val);
                ByteUtils.Buffer.LE.addNat16(buf, nat16val);
                ByteUtils.Buffer.LE.addInt8(buf, int8val);
                ByteUtils.Buffer.LE.addInt16(buf, int16val);

                // Read them back in sequence
                let restored8 = ByteUtils.Buffer.LE.readNat8(buf, 0);
                let restored16 = ByteUtils.Buffer.LE.readNat16(buf, 1);
                let restoredI8 = ByteUtils.Buffer.LE.readInt8(buf, 3);
                let restoredI16 = ByteUtils.Buffer.LE.readInt16(buf, 4);

                assert restored8 == nat8val;
                assert restored16 == nat16val;
                assert restoredI8 == int8val;
                assert restoredI16 == int16val;
            },
        );

        test(
            "Buffer operations large range testing - LE",
            func() {

                // Test 1,000 random values for buffer operations (reduced from 10k for performance)
                for (i in Iter.range(0, 999)) {
                    let buf = Buffer.Buffer<Nat8>(16);

                    let nat16_val : Nat16 = fuzz.nat16.random();
                    let nat32_val : Nat32 = fuzz.nat32.random();
                    let int16_val : Int16 = fuzz.int16.random();
                    let int32_val : Int32 = fuzz.int32.random();

                    ByteUtils.Buffer.LE.addNat16(buf, nat16_val);
                    ByteUtils.Buffer.LE.addNat32(buf, nat32_val);
                    ByteUtils.Buffer.LE.addInt16(buf, int16_val);
                    ByteUtils.Buffer.LE.addInt32(buf, int32_val);

                    let restored_nat16 = ByteUtils.Buffer.LE.readNat16(buf, 0);
                    let restored_nat32 = ByteUtils.Buffer.LE.readNat32(buf, 2);
                    let restored_int16 = ByteUtils.Buffer.LE.readInt16(buf, 6);
                    let restored_int32 = ByteUtils.Buffer.LE.readInt32(buf, 8);

                    assert restored_nat16 == nat16_val;
                    assert restored_nat32 == nat32_val;
                    assert restored_int16 == int16_val;
                    assert restored_int32 == int32_val;
                };
            },
        );

        test(
            "writeLEB128_64/readLEB128_64 buffer operations",
            func() {
                let buf = Buffer.Buffer<Nat8>(32);

                // Fill buffer with zeros
                for (_ in Iter.range(0, 31)) {
                    buf.add(0);
                };

                // Test values with known encodings
                let testValues : [(Nat64, Nat, [Nat8])] = [
                    (0, 0, [0x00]),
                    (127, 5, [0x7F]),
                    (128, 10, [0x80, 0x01]),
                    (624485, 15, [0xE5, 0x8E, 0x26]),
                ];

                for ((value, offset, expectedBytes) in testValues.vals()) {
                    // Write at specific offset
                    ByteUtils.Buffer.writeLEB128_64(buf, offset, value);

                    // Verify bytes were written correctly
                    for (i in Iter.range(0, expectedBytes.size() - 1)) {
                        assert buf.get(offset + i) == expectedBytes[i];
                    };

                    // Create a slice buffer to read from
                    let sliceBuf = Buffer.Buffer<Nat8>(expectedBytes.size());
                    for (i in Iter.range(0, expectedBytes.size() - 1)) {
                        sliceBuf.add(buf.get(offset + i));
                    };

                    // Read back and verify
                    let restored = ByteUtils.Buffer.readLEB128_64(sliceBuf);
                    assert restored == value;
                };
            },
        );

        test(
            "writeLEB128_64 large range testing with fuzzing",
            func() {

                // Test 100 random values for performance
                label testing_loop for (i in Iter.range(0, 99)) {
                    let buf = Buffer.Buffer<Nat8>(32);

                    // Fill buffer with zeros
                    for (_ in Iter.range(0, 31)) {
                        buf.add(0);
                    };

                    let value : Nat64 = fuzz.nat64.random();
                    let offset = 5; // Write at offset 5

                    // Write using writeLEB128_64
                    ByteUtils.Buffer.writeLEB128_64(buf, offset, value);

                    // Create a slice buffer starting from the offset
                    let sliceBuf = Buffer.Buffer<Nat8>(10);
                    var j = offset;
                    while (j < buf.size() and buf.get(j) != 0) {
                        sliceBuf.add(buf.get(j));
                        j += 1;
                        // Handle case where last byte doesn't have continuation bit
                        if (j > offset and (buf.get(j - 1) & 0x80) == 0) {
                            break testing_loop;
                        };
                    };

                    // Read back and verify
                    let restored = ByteUtils.Buffer.readLEB128_64(sliceBuf);
                    assert restored == value;
                };
            },
        );

        test(
            "writeSLEB128_64/readSLEB128_64 buffer operations",
            func() {
                let buf = Buffer.Buffer<Nat8>(32);

                // Fill buffer with zeros
                for (_ in Iter.range(0, 31)) {
                    buf.add(0);
                };

                // Test values with known encodings
                let testValues : [(Int64, Nat, [Nat8])] = [
                    (0, 0, [0x00]),
                    (1, 5, [0x01]),
                    (-1, 10, [0x7F]),
                    (63, 15, [0x3F]),
                    (-64, 20, [0x40]),
                    (64, 25, [0xC0, 0x00]),
                ];

                for ((value, offset, expectedBytes) in testValues.vals()) {
                    // Write at specific offset
                    ByteUtils.Buffer.writeSLEB128_64(buf, offset, value);

                    // Verify bytes were written correctly
                    for (i in Iter.range(0, expectedBytes.size() - 1)) {
                        assert buf.get(offset + i) == expectedBytes[i];
                    };

                    // Create a slice buffer to read from
                    let sliceBuf = Buffer.Buffer<Nat8>(expectedBytes.size());
                    for (i in Iter.range(0, expectedBytes.size() - 1)) {
                        sliceBuf.add(buf.get(offset + i));
                    };

                    // Read back and verify
                    let restored = ByteUtils.Buffer.readSLEB128_64(sliceBuf);
                    assert restored == value;
                };
            },
        );

        test(
            "writeSLEB128_64 large range testing with fuzzing",
            func() {

                // Test 100 random values for performance
                for (i in Iter.range(0, 99)) {
                    let buf = Buffer.Buffer<Nat8>(32);

                    // Fill buffer with zeros
                    for (_ in Iter.range(0, 31)) {
                        buf.add(0);
                    };

                    let value : Int64 = fuzz.int64.random();
                    let offset = 5; // Write at offset 5

                    // First, encode the value to know its expected length
                    let expectedEncoding = ByteUtils.toSLEB128_64(value);
                    let expectedLength = expectedEncoding.size();

                    // Write using writeSLEB128_64
                    ByteUtils.Buffer.writeSLEB128_64(buf, offset, value);

                    // Create a slice buffer with the known length
                    let sliceBuf = Buffer.Buffer<Nat8>(expectedLength);
                    for (j in Iter.range(0, expectedLength - 1)) {
                        sliceBuf.add(buf.get(offset + j));
                    };

                    // Read back and verify
                    let restored = ByteUtils.Buffer.readSLEB128_64(sliceBuf);
                    assert restored == value;
                };
            },
        );

        test(
            "writeLEB128_64 and writeSLEB128_64 at multiple offsets",
            func() {
                let buf = Buffer.Buffer<Nat8>(64);

                // Fill buffer with zeros
                for (_ in Iter.range(0, 63)) {
                    buf.add(0);
                };

                // Write multiple values at different offsets
                let lebValue1 : Nat64 = 12345;
                let lebValue2 : Nat64 = 128;
                let slebValue1 : Int64 = -12345;
                let slebValue2 : Int64 = 64;

                ByteUtils.Buffer.writeLEB128_64(buf, 0, lebValue1);
                ByteUtils.Buffer.writeLEB128_64(buf, 10, lebValue2);
                ByteUtils.Buffer.writeSLEB128_64(buf, 20, slebValue1);
                ByteUtils.Buffer.writeSLEB128_64(buf, 30, slebValue2);

                // Create slice buffers and verify each value
                // LEB value 1 at offset 0 (should be [0xB9, 0x60])
                let slice1 = Buffer.Buffer<Nat8>(2);
                slice1.add(buf.get(0));
                slice1.add(buf.get(1));
                let restored1 = ByteUtils.Buffer.readLEB128_64(slice1);
                assert restored1 == lebValue1;

                // LEB value 2 at offset 10 (should be [0x80, 0x01])
                let slice2 = Buffer.Buffer<Nat8>(2);
                slice2.add(buf.get(10));
                slice2.add(buf.get(11));
                let restored2 = ByteUtils.Buffer.readLEB128_64(slice2);
                assert restored2 == lebValue2;

                // SLEB value 1 at offset 20 (should be [0xC7, 0x9F, 0x7F])
                let slice3 = Buffer.Buffer<Nat8>(3);
                slice3.add(buf.get(20));
                slice3.add(buf.get(21));
                slice3.add(buf.get(22));
                let restored3 = ByteUtils.Buffer.readSLEB128_64(slice3);
                assert restored3 == slebValue1;

                // SLEB value 2 at offset 30 (should be [0xC0, 0x00])
                let slice4 = Buffer.Buffer<Nat8>(2);
                slice4.add(buf.get(30));
                slice4.add(buf.get(31));
                let restored4 = ByteUtils.Buffer.readSLEB128_64(slice4);
                assert restored4 == slebValue2;
            },
        );
    },
);

suite(
    "ByteUtils Test Vectors - Exact Byte Comparisons",
    func() {

        func byte_comparison<A>(
            from : (A) -> [Nat8],
            to : (Iter.Iter<Nat8>) -> A,
            test_vectors : [(A, [Nat8])],
            is_equal : (A, A) -> Bool,
            to_text : (A) -> Text,
        ) {
            for ((value, expected) in test_vectors.vals()) {
                let bytes = from(value);
                if (bytes != expected) {
                    Debug.print(debug_show { value = to_text(value); expected; bytes });
                    assert false;
                };

                let restored = to(bytes.vals());
                if (not is_equal(restored, value)) {
                    Debug.print(debug_show { value = to_text(value); restored = to_text(restored); expected; bytes });
                    assert false;
                };
            };
        };

        func bidirectional_byte_comparison<A>(
            little_endian : {
                from : (A) -> [Nat8];
                to : (Iter.Iter<Nat8>) -> A;
            },
            big_endian : {
                from : (A) -> [Nat8];
                to : (Iter.Iter<Nat8>) -> A;
            },

            test_vectors_in_little_endian : [(A, [Nat8])],
            is_equal : (A, A) -> Bool,
            to_text : (A) -> Text,
        ) {
            test(
                "Little Endian byte comparison",
                func() {
                    byte_comparison(little_endian.from, little_endian.to, test_vectors_in_little_endian, is_equal, to_text);
                },
            );

            test(
                "Big Endian byte comparison",
                func() {
                    byte_comparison(
                        big_endian.from,
                        big_endian.to,
                        Array.map<(A, [Nat8]), (A, [Nat8])>(
                            test_vectors_in_little_endian,
                            func(test_vector : (A, [Nat8])) : (A, [Nat8]) {
                                (test_vector.0, Array.reverse(test_vector.1));
                            },
                        ),
                        is_equal,
                        to_text,
                    );
                },
            );
        };

        suite(
            "Nat8",
            func() {
                bidirectional_byte_comparison<Nat8>(
                    { from = ByteUtils.LE.fromNat8; to = ByteUtils.LE.toNat8 },
                    { from = ByteUtils.BE.fromNat8; to = ByteUtils.BE.toNat8 },
                    [
                        (0, [0x00]),
                        (1, [0x01]),
                        (127, [0x7F]),
                        (128, [0x80]),
                        (255, [0xFF]),
                    ],
                    Nat8.equal,
                    Nat8.toText,
                );
            },
        );

        suite(
            "Nat16",
            func() {
                bidirectional_byte_comparison<Nat16>(
                    { from = ByteUtils.LE.fromNat16; to = ByteUtils.LE.toNat16 },
                    { from = ByteUtils.BE.fromNat16; to = ByteUtils.BE.toNat16 },
                    [
                        (0x0000, [0x00, 0x00]),
                        (0x0001, [0x01, 0x00]),
                        (0x007F, [0x7F, 0x00]),
                        (0x0080, [0x80, 0x00]),
                        (0x00FF, [0xFF, 0x00]),
                        (0x0100, [0x00, 0x01]),
                        (0x1234, [0x34, 0x12]),
                        (0xFFFF, [0xFF, 0xFF]),
                    ],
                    Nat16.equal,
                    Nat16.toText,
                );
            },
        );
        suite(
            "Nat32",
            func() {
                bidirectional_byte_comparison<Nat32>(
                    { from = ByteUtils.LE.fromNat32; to = ByteUtils.LE.toNat32 },
                    { from = ByteUtils.BE.fromNat32; to = ByteUtils.BE.toNat32 },
                    [
                        (0x00000000, [0x00, 0x00, 0x00, 0x00]),
                        (0x00000001, [0x01, 0x00, 0x00, 0x00]),
                        (0x000000FF, [0xFF, 0x00, 0x00, 0x00]),
                        (0x00000100, [0x00, 0x01, 0x00, 0x00]),
                        (0x12345678, [0x78, 0x56, 0x34, 0x12]),
                        (0x7FFFFFFF, [0xFF, 0xFF, 0xFF, 0x7F]),
                        (0x80000000, [0x00, 0x00, 0x00, 0x80]),
                        (0xFFFFFFFF, [0xFF, 0xFF, 0xFF, 0xFF]),
                    ],
                    Nat32.equal,
                    Nat32.toText,
                );
            },
        );

        suite(
            "Nat64",
            func() {
                bidirectional_byte_comparison<Nat64>(
                    { from = ByteUtils.LE.fromNat64; to = ByteUtils.LE.toNat64 },
                    { from = ByteUtils.BE.fromNat64; to = ByteUtils.BE.toNat64 },
                    [
                        (0x0000000000000000, [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]),
                        (0x0000000000000001, [0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]),
                        (0x00000000000000FF, [0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]),
                        (0x0000000000000100, [0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]),
                        (0x123456789ABCDEF0, [0xF0, 0xDE, 0xBC, 0x9A, 0x78, 0x56, 0x34, 0x12]),
                        (0x7FFFFFFFFFFFFFFF, [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x7F]),
                        (0x8000000000000000, [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80]),
                        (0xFFFFFFFFFFFFFFFF, [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]),
                    ],
                    Nat64.equal,
                    Nat64.toText,
                );
            },
        );

        suite(
            "Int8",
            func() {
                bidirectional_byte_comparison<Int8>(
                    { from = ByteUtils.LE.fromInt8; to = ByteUtils.LE.toInt8 },
                    { from = ByteUtils.BE.fromInt8; to = ByteUtils.BE.toInt8 },
                    [
                        (-128, [0x80]),
                        (-127, [0x81]),
                        (-1, [0xFF]),
                        (0, [0x00]),
                        (1, [0x01]),
                        (127, [0x7F]),
                    ],
                    Int8.equal,
                    Int8.toText,
                );
            },
        );

        suite(
            "Int16",
            func() {
                bidirectional_byte_comparison<Int16>(
                    { from = ByteUtils.LE.fromInt16; to = ByteUtils.LE.toInt16 },
                    { from = ByteUtils.BE.fromInt16; to = ByteUtils.BE.toInt16 },
                    [
                        (-32768, [0x00, 0x80]),
                        (-32767, [0x01, 0x80]),
                        (-1, [0xFF, 0xFF]),
                        (0, [0x00, 0x00]),
                        (1, [0x01, 0x00]),
                        (32767, [0xFF, 0x7F]),
                        (0x1234, [0x34, 0x12]),
                        (-0x1234, [0xCC, 0xED]),
                    ],
                    Int16.equal,
                    Int16.toText,
                );
            },
        );

        suite(
            "Int32",
            func() {
                bidirectional_byte_comparison<Int32>(
                    { from = ByteUtils.LE.fromInt32; to = ByteUtils.LE.toInt32 },
                    { from = ByteUtils.BE.fromInt32; to = ByteUtils.BE.toInt32 },
                    [
                        (-2147483648, [0x00, 0x00, 0x00, 0x80]),
                        (-2147483647, [0x01, 0x00, 0x00, 0x80]),
                        (-1, [0xFF, 0xFF, 0xFF, 0xFF]),
                        (0, [0x00, 0x00, 0x00, 0x00]),
                        (1, [0x01, 0x00, 0x00, 0x00]),
                        (2147483647, [0xFF, 0xFF, 0xFF, 0x7F]),
                        (0x12345678, [0x78, 0x56, 0x34, 0x12]),
                        (-0x12345678, [0x88, 0xA9, 0xCB, 0xED]),
                    ],
                    Int32.equal,
                    Int32.toText,
                );
            },
        );

        suite(
            "Int64",
            func() {
                bidirectional_byte_comparison<Int64>(
                    { from = ByteUtils.LE.fromInt64; to = ByteUtils.LE.toInt64 },
                    { from = ByteUtils.BE.fromInt64; to = ByteUtils.BE.toInt64 },
                    [
                        (-9223372036854775808, [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80]),
                        (-9223372036854775807, [0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80]),
                        (-1, [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]),
                        (0, [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]),
                        (1, [0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]),
                        (9223372036854775807, [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x7F]),
                        (0x123456789ABCDEF0, [0xF0, 0xDE, 0xBC, 0x9A, 0x78, 0x56, 0x34, 0x12]),
                    ],
                    Int64.equal,
                    Int64.toText,
                );
            },
        );

        suite(
            "Float",
            func() {
                bidirectional_byte_comparison<Float>(
                    { from = ByteUtils.LE.fromFloat; to = ByteUtils.LE.toFloat },
                    { from = ByteUtils.BE.fromFloat; to = ByteUtils.BE.toFloat },
                    [
                        (0.0, [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]),
                        (1.0, [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x3F]),
                        (-1.0, [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0xBF]),
                        (2.0, [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40]),
                        (0.5, [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xE0, 0x3F]),
                        (3.14159265359, [0xEA, 0x2E, 0x44, 0x54, 0xFB, 0x21, 0x09, 0x40]),
                        // (2.718281828, [0x69, 0x57, 0x14, 0x8B, 0x0A, 0xBF, 0x05, 0x40]),
                    ],
                    func(a : Float, b : Float) : Bool {
                        let epsilon : Float = 0.0000001;
                        Float.equalWithin(a, b, epsilon);
                    },
                    Float.toText,
                );
            },
        );

        test(
            "Extended Float test vectors - special values",
            func() {

                // Test very small and very large numbers
                let verySmall = 1e-300;
                let veryLarge = 1e300;

                let smallBytes = ByteUtils.LE.fromFloat(verySmall);
                let smallRestored = ByteUtils.LE.toFloat(smallBytes.vals());
                assert smallRestored == verySmall;

                let largeBytes = ByteUtils.LE.fromFloat(veryLarge);
                let largeRestored = ByteUtils.LE.toFloat(largeBytes.vals());
                assert largeRestored == veryLarge;
            },
        );

        test(
            "Mathematical constants test vectors",
            func() {
                // Test mathematical constants with high precision
                let constants = [
                    3.141592653589793, // π
                    2.718281828459045, // e
                    1.414213562373095, // √2
                    1.618033988749895, // φ (golden ratio)
                    0.5772156649015329, // γ (Euler-Mascheroni constant)
                ];

                for (value in constants.vals()) {
                    // Test Little Endian
                    let leBytesFloat = ByteUtils.LE.fromFloat(value);
                    let leRestoredFloat = ByteUtils.LE.toFloat(leBytesFloat.vals());
                    assert leRestoredFloat == value;

                    // Test Big Endian
                    let beBytesFloat = ByteUtils.BE.fromFloat(value);
                    let beRestoredFloat = ByteUtils.BE.toFloat(beBytesFloat.vals());
                    assert beRestoredFloat == value;
                };
            },
        );

        test(
            "Powers of 10 test vectors",
            func() {
                // Test powers of 10 from 10^-15 to 10^15
                let powers = [
                    1e-15,
                    1e-10,
                    1e-5,
                    1e-1,
                    1e0,
                    1e1,
                    1e2,
                    1e3,
                    1e4,
                    1e5,
                    1e6,
                    1e7,
                    1e8,
                    1e9,
                    1e10,
                    1e11,
                    1e12,
                    1e13,
                    1e14,
                    1e15,
                ];

                for (value in powers.vals()) {
                    // Test Little Endian
                    let leBytesFloat = ByteUtils.LE.fromFloat(value);
                    let leRestoredFloat = ByteUtils.LE.toFloat(leBytesFloat.vals());
                    assert leRestoredFloat == value;

                    // Test Big Endian
                    let beBytesFloat = ByteUtils.BE.fromFloat(value);
                    let beRestoredFloat = ByteUtils.BE.toFloat(beBytesFloat.vals());
                    assert beRestoredFloat == value;

                    // Test negative values
                    let negValue = -value;
                    let leNegBytes = ByteUtils.LE.fromFloat(negValue);
                    let leNegRestored = ByteUtils.LE.toFloat(leNegBytes.vals());
                    assert leNegRestored == negValue;

                    let beNegBytes = ByteUtils.BE.fromFloat(negValue);
                    let beNegRestored = ByteUtils.BE.toFloat(beNegBytes.vals());
                    assert beNegRestored == negValue;
                };
            },
        );

        test(
            "Fraction test vectors",
            func() {
                // Test common fractions
                let fractions = [
                    1.0 / 3.0, // 0.333...
                    2.0 / 3.0, // 0.666...
                    1.0 / 7.0, // 0.142857...
                    22.0 / 7.0, // π approximation
                    355.0 / 113.0, // Better π approximation
                    1.0 / 9.0, // 0.111...
                    5.0 / 6.0, // 0.833...
                    7.0 / 8.0, // 0.875
                ];

                for (value in fractions.vals()) {
                    // Test Little Endian
                    let leBytesFloat = ByteUtils.LE.fromFloat(value);
                    let leRestoredFloat = ByteUtils.LE.toFloat(leBytesFloat.vals());
                    assert leRestoredFloat == value;

                    // Test Big Endian
                    let beBytesFloat = ByteUtils.BE.fromFloat(value);
                    let beRestoredFloat = ByteUtils.BE.toFloat(beBytesFloat.vals());
                    assert beRestoredFloat == value;
                };
            },
        );
    },
);
